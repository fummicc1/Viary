import ComposableArchitecture
import Tagged
import Entities
import SwiftUI
import EmotionDetection
import Repositories
import Utils


public struct EditViary: ReducerProtocol {

    @Dependency(\.emotionDetector) var emotionDetector
    @Dependency(\.viaryRepository) var viaryRepository

    public init() {
    }

    public enum Mode: Equatable {
        case edit
        case view
    }

    public struct State: Equatable {
        public var original: Viary
        public var editable: Viary
        public var resolved: [Viary.Message.ID: Bool]
        public var saveStatus: AsyncStatus<Int> = .idle
        public var scrollContentHeight: [Viary.Message.ID: CGFloat] = [:]
        public var focusedMessage: Viary.Message?
        public var mode: Mode = .view

        var messages: [Viary.Message] {
            editable.messages.elements
        }

        var totalSentece: String {
            editable.message
        }

        var canEditable: Bool {
            mode == .edit
        }

        public init(original: Viary, editable: Viary) {
            self.original = original
            self.editable = editable
            self.resolved = Dictionary(uniqueKeysWithValues: editable.messages.map(\.id).map { ($0, true) })
        }
    }

    public enum Action: Equatable {
        case analyze(messageID: Tagged<Viary.Message, String>)

        case editMessageSentence(id: Tagged<Viary.Message, String>, sentence: String)
        case replace(id: Tagged<Viary.Message, String>, message: Viary.Message, resolved: Bool)

        case tapMessage(id: Viary.Message.ID)
        case stopEditing
        case didAdjustMessageHeight(id: Viary.Message.ID, height: CGFloat)
        case toggleMode

        case editMessageEmotion(
            id: Tagged<Viary.Message, String>,
            emotionKind: Emotion.Kind,
            prob: Double
        )

        case save
        case saved
    }

    public enum Error: LocalizedError {
        case messageNotFound(id: Tagged<Viary.Message, String>)
    }

    public func reduce(into state: inout State, action: Action) -> EffectTask<Action> {
        switch action {
        case let .editMessageSentence(id, sentence):
            guard state.canEditable else {
                return .none
            }
            state.editable.messages[id: id]?.sentence = sentence
            state.resolved[id] = false

        case let .editMessageEmotion(id, emotionKind, prob):
            guard state.canEditable else {
                return .none
            }
            let total: Double = 100
            let prevScore = Double(state.editable.messages[id: id]?.emotions[emotionKind]?.score ?? 0)
            state.editable.messages[id: id]?.emotions[emotionKind]?.score = Int(total * prob)
            let emotions = state.editable.messages[id: id]?.emotions ?? [:]
            let remaining = total - prevScore
            let newRemaining = total * ( 1 - prob )
            for (kind, emotion) in emotions {
                if kind == emotionKind {
                    continue
                }
                var newScore: Double
                if remaining > 0 {
                    newScore = Double(emotion.score) / remaining * newRemaining
                } else {
                    newScore = 0
                }
                let zeroCase = newRemaining / Double(Emotion.Kind.allCases.count - 1)
                if newScore < zeroCase {
                    newScore = zeroCase
                }
                state.editable.messages[id: id]?.emotions[kind]?.score = Int(newScore)
            }
        case let .analyze(messageID):
            guard let message = state.editable.messages[id: messageID] else {
                return .none
            }
            return .task { [state] in
                let emotions = await emotionDetector.infer(text: message.sentence, lang: message.lang)
                if var message = state.messages.first(where: { $0.id == messageID }) {
                    for kind in message.emotions.map(\.key) {
                        guard let i = Emotion.Kind.allCases.firstIndex(of: kind) else {
                            continue
                        }
                        message.emotions[kind]?.score = Int(emotions[i])
                    }
                    return .replace(id: messageID, message: message, resolved: true)
                }
                throw Error.messageNotFound(id: messageID)
            }
        case let .replace(id, message, resolved):
            guard state.canEditable else {
                return .none
            }
            guard state.editable.messages.map(\.id).contains(id) else {
                return .none
            }
            state.editable.messages[id: id] = message
            state.resolved[id] = resolved

        case let .tapMessage(id):
            state.mode = .edit
            state.focusedMessage = state.messages.first(where: { $0.id == id })

        case .stopEditing:
            state.focusedMessage = nil
            state.mode = .view

        case .toggleMode:
            state.mode = state.mode == .edit ? .view : .edit
            if state.mode == .view {
                state.focusedMessage = nil
            }

        case let .didAdjustMessageHeight(id, height):
            state.scrollContentHeight[id] = height

        case .save:
            if state.saveStatus.isLoading {
                return .none
            }
            state.saveStatus.start()
            return .task { [state] in
                try await viaryRepository.update(id: state.original.id, viary: state.editable)
                return .saved
            }
        case .saved:
            state.saveStatus = .success(0)
        }
        return .none
    }
}
