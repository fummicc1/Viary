import ComposableArchitecture
import Tagged
import Entities
import SwiftUI
import EmotionDetection
import Repositories


public struct EditViary: ReducerProtocol {

    @Dependency(\.emotionDetector) var emotionDetector
    @Dependency(\.viaryRepository) var viaryRepository

    public struct State: Equatable {
        public var original: Viary
        public var editable: Viary
        public var resolved: [Viary.Message.ID: Bool]

        var messages: [Viary.Message] {
            editable.messages.elements
        }

        var totalSentece: String {
            editable.message
        }

        public init(original: Viary, editable: Viary) {
            self.original = original
            self.editable = editable
            self.resolved = Dictionary(uniqueKeysWithValues: editable.messages.map(\.id).map { ($0, true) })
        }
    }

    public enum Action: Equatable {
        case analyze(messageID: Tagged<Viary.Message, String>)
        case editMessage(id: Tagged<Viary.Message, String>, sentence: String)
        case replace(id: Tagged<Viary.Message, String>, message: Viary.Message, resolved: Bool)
        case save
        case saved
    }

    public enum Error: LocalizedError {
        case messageNotFound(id: Tagged<Viary.Message, String>)
    }

    public func reduce(into state: inout State, action: Action) -> EffectTask<Action> {
        switch action {
        case let .editMessage(id, sentence):
            state.editable.messages[id: id]?.sentence = sentence
            state.resolved[id] = false
        case let .analyze(messageID):
            guard let message = state.editable.messages[id: messageID] else {
                return .none
            }
            return .task { [state] in
                let emotions = await emotionDetector.infer(text: message.sentence, lang: message.lang)
                if var message = state.messages.first(where: { $0.id == messageID }) {
                    for i in message.emotions.indices {
                        message.emotions[i].score = Int(emotions[i] * 100)
                    }
                    return .replace(id: messageID, message: message, resolved: true)
                }
                throw Error.messageNotFound(id: messageID)
            }
        case let .replace(id, message, resolved):
            guard state.editable.messages.map(\.id).contains(id) else {
                return .none
            }
            state.editable.messages[id: id] = message
            state.resolved[id] = resolved
        case .save:
            return .task { [state] in
                try await viaryRepository.update(id: state.editable.id, viary: state.editable)
                return .saved
            }
        case .saved:
            break
        }
        return .none
    }
}
