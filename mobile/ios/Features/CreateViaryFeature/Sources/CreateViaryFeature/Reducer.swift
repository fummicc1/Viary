import ComposableArchitecture
import Entities
import Foundation

public struct CreateViaryReducer: ReducerProtocol {
    public struct State: Equatable {
        public var message: String
        public var lang: Lang
        public var date: Date
        public var saveStatus: 

        public init(message: String = "", lang: Lang = .en, date: Date = .now) {
            self.message = message
            self.lang = lang
            self.date = date
        }
    }

    public enum Action: Equatable {
        case editMessage(String)
        case editLang(Lang)
        case editDate(Date)
        case save
        case saved(TaskResult<Viary>)
    }

    public func reduce(into state: inout State, action: Action) -> EffectTask<Action> {
        switch action {
        case .editMessage(let message):
            state.message = message
        case .editLang(let lang):
            state.lang = lang
        case .editDate(let date):
            state.date = date
        case .save:

        }
    }
}
