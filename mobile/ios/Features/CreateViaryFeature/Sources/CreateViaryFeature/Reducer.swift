import Combine
import ComposableArchitecture
import Dependencies
import Entities
import Foundation
import Repositories
import SpeechToText
import Utils

public struct CreateViary: ReducerProtocol {

    @Dependency(\.viaryRepository) var viaryRepository
    @Dependency(\.speechToTextService) var speechToTextService
    @Dependency(\.uuid) var uuid
    private var cancellables: Set<AnyCancellable> = []

    public struct InputState: Equatable {
        public var type: InputType
        public var message: String

        public init(type: InputType = .keyboard, message: String = "") {
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

        public var message: String {
            messages.map(\.message).joined(separator: "\n")
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
    }

    public enum Action: Equatable {
        case onAppear
        case editMessage(String)
        case endEditing(String)
        case editLang(Lang)
        case editInputType(InputType)
        case startRecording
        case stopRecording
        case updateSpeechStatus(SpeechStatus)
        case editDate(Date)
        case save
        case saved(TaskResult<Bool>)
    }

    public func reduce(into state: inout State, action: Action) -> EffectTask<Action> {
        switch action {
        case .onAppear:
            return EffectTask.run { send in
                for await speechStatus in speechToTextService.speechStatus.values {
                    await send(.updateSpeechStatus(speechStatus))
                }
            }

        case .editMessage(let message):
            state.currentInput.message = message

        case .endEditing:
            let message = state.currentInput.message
            let newMessage = Viary.Message(
                message: message,
                lang: state.currentLang
            )
            state.messages.append(newMessage)
            state.currentInput.clear()

        case .editLang(let lang):
            state.currentLang = lang

        case .startRecording:
            state.speechStatus = .started
            return .fireAndForget {
                try await speechToTextService.start()
            }

        case .stopRecording:
            return .fireAndForget {
                try await speechToTextService.stop()
            }

        case .updateSpeechStatus(let status):
            state.speechStatus = status

        case .editDate(let date):
            state.date = date
        case .editInputType(let inputType):
            state.currentInput.type = inputType
        case .save:
            state.saveStatus.start()
            return .task { [state] in
                let viary = Viary(
                    id: .init(rawValue: uuid().uuidString),
                    messages: state.messages,
                    lang: state.currentLang,
                    date: state.date,
                    emotions: []
                )
                try await viaryRepository.create(viary: viary)
                return .saved(.success(true))
            } catch: { error in
                return .saved(.failure(error))
            }
        case .saved(let result):
            switch result {
            case .success(let ok):
                state.saveStatus = .success(ok)
            case .failure(let error):
                state.saveStatus = .fail(error)
            }
        }
        return .none
    }
}
