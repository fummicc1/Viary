import ComposableArchitecture
import Dependencies
import Entities
import Tagged
import Foundation
import Repositories
import EmotionDetection
import SpeechToText
import Utils
import Ja2En

public struct CreateViary: Reducer, Sendable {

    @Dependency(\.viaryRepository) var viaryRepository
    @Dependency(\.speechToTextService) var speechToTextService
    @Dependency(\.emotionDetector) var emotionDetector
    @Dependency(\.ja2En) var ja2EnService
    @Dependency(\.uuid) var uuid
    @Dependency(\.date) var date

    public init() {
    }

    public struct InputState: Equatable {
        public var type: InputType
        public var message: String

        public init(type: InputType = .voice, message: String = "") {
            self.type = type
            self.message = message
        }

        public mutating func clear() {
            message = ""
        }
    }

    public enum InputType: String, Identifiable, Equatable, CaseIterable {
        case keyboard
        case voice

        public var id: String {
            rawValue
        }

        var description: String {
            switch self {
            case .keyboard:
                return "キーボード"
            case .voice:
                return "音声"
            }
        }
    }

    public struct State: Equatable {
        public var messages: [Viary.Message]
        public var currentLang: Lang
        public var currentInput: InputState
        public var speechStatus: SpeechStatus
        public var date: Date
        public var saveStatus: AsyncStatus<Bool>

        public var isUsingEnglish: Bool {
            currentLang == .en
        }

        public var message: String {
            messages.map(\.sentence).joined(separator: "\n")
        }

        public init(
            messages: [Viary.Message] = [],
            currentLang: Lang = .en,
            currentInput: InputState = .init(),
            speechStatus: SpeechStatus = .idle,
            date: Date = .now,
            saveStatus: AsyncStatus<Bool> = .idle
        ) {
            self.messages = messages
            self.currentLang = currentLang
            self.currentInput = currentInput
            self.speechStatus = speechStatus
            self.date = date
            self.saveStatus = saveStatus
        }

        public func isValidInput(now: Date) -> Bool {
            !message.isEmpty && date.timeIntervalSince(now) < 0 && speechStatus == .idle && !saveStatus.isLoading
        }
    }

    public enum Action: Equatable {
        case onAppear
        case editMessage(String)
        case endEditing(String)
        case editLang(Lang)
        case didTapLang
        case editInputType(InputType)
        case startRecording
        case stopRecording
        case updateSpeechStatus(SpeechStatus)
        case editDate(Date)
        case save
        case saved(TaskResult<Bool>)
        case delete(Viary.Message)
        case onDisappear
    }

    public func reduce(into state: inout State, action: Action) -> Effect<Action> {
        switch action {
        case .onAppear:
            return .run { send in
                for await speechStatus in await speechToTextService.speechStatus {
                    await send(.updateSpeechStatus(speechStatus))
                }
            }

        case .editMessage(let message):
            state.currentInput.message = message

        case .endEditing:
            let message = state.currentInput.message
            if message.isEmpty {
                return .none
            }
            let newMessage = Viary.Message(
                viaryID: Tagged(""),
                id: Tagged(UUID().uuidString),
                sentence: message,
                lang: state.currentLang
            )
            state.messages.append(newMessage)
            state.currentInput.clear()

        case .editLang(let lang):
            state.currentLang = lang

        case .didTapLang:
            let lang = state.currentLang
            return .run {
                try await self.speechToTextService.change(locale: lang.next().locale)
                await $0(.editLang(lang.next()))
            }

        case .startRecording:
			return .run { _ in
                try await speechToTextService.start()
            }

        case .stopRecording:
			return .run { _ in
                try await speechToTextService.stop()
            }

        case .updateSpeechStatus(let status):
            state.speechStatus = status
            if state.currentInput.type == .voice, case let SpeechStatus.speeching(model) = status {
                state.currentInput.message = model.text
            }
            if case let SpeechStatus.stopped(model) = status {
                return .send(.endEditing(model.text))
            }

        case .editDate(let date):
            state.date = date
        case .editInputType(let inputType):
            state.currentInput.type = inputType
        case .save:
            if state.saveStatus.isLoading {
                return .none
            }
            state.saveStatus.start()
			return .run { [state] send in
				do {
					var messages = state.messages

					for (i, message) in messages.enumerated() {
						var sentence: String = message.sentence
						var lang: Lang = message.lang
						if message.lang == .ja {
							do {
								sentence = try await ja2EnService.translate(message: sentence)
								lang = .en
							} catch {
								// TODO: Error Handling
							}
						}
						let newScore = await emotionDetector.infer(text: sentence, lang: lang)
						let emotions = Emotion.Kind.allCases.indices.compactMap { index -> (Emotion.Kind, Emotion)? in
							if newScore.count <= index {
								return nil
							}
							let kind = Emotion.Kind.allCases[index]
							let score = newScore[index]
							return (
								kind,
								Emotion(
									sentence: message.sentence,
									score: Int(score),
									kind: kind
								)
							)
						}
						messages[i].emotions = Dictionary(uniqueKeysWithValues: emotions)
					}

					let viary = Viary(
						id: .init(rawValue: uuid().uuidString),
						messages: IdentifiedArray(uniqueElements: messages),
						date: state.date
					)
					var emotionsPerMessage: [Viary.Message.ID: [Emotion.Kind: Emotion]] = [:]
					for message in viary.messages {
						emotionsPerMessage[message.id] = message.emotions
					}
					try await viaryRepository.create(
						viary: viary,
						with: emotionsPerMessage
					)
					await send(.saved(.success(true)))
				} catch {
					await send(.saved(.failure(error)))
				}
            }
        case .saved(let result):
            switch result {
            case .success(let ok):
                state.saveStatus = .success(ok)
            case .failure(let error):
                state.saveStatus = .fail(error)
            }

        case .delete(let message):
            state.messages.removeAll(where: { $0 == message })
        case .onDisappear:
            return .run { _ in
                try await speechToTextService.stop()
            }
        }
        return .none
    }
}
