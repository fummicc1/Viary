import ComposableArchitecture
import Entities
import SwiftUI


public struct EditViary: ReducerProtocol {

    public struct State: Equatable {
        public var original: Viary
        public var editable: Viary

        var messages: [Viary.Message] {
            editable.messages
        }

        var totalSentece: String {
            editable.message
        }

        public init(original: Viary, editable: Viary) {
            self.original = original
            self.editable = editable
        }
    }

    public enum Action: Equatable {
        case editEmotionScore(emotion: Emotion, score: Int)
        case save
        case saved
    }

    public func reduce(into state: inout State, action: Action) -> EffectTask<Action> {
        switch action {
        case let .editEmotionScore(emotion, score):
            guard let index = state.editable.emotions.firstIndex(where: { $0.kind == emotion.kind }) else {
                return .none
            }
            state.editable.emotions[index].score = score
        case .save:
            break
        case .saved:
            break
        }
        return .none
    }
}
