import ComposableArchitecture
import Entities
import Foundation
import Repositories
import SpeechToText
import Utils

public struct CreateViary: ReducerProtocol {

    @Dependency(\.viaryRepository) var viaryRepository
    @Dependency(\.uuid) var uuid

    public enum TextInput: Equatable {
        case text
        case voice(SpeechStatus)
    }

    public struct State: Equatable {
        public var message: String
        public var lang: Lang
        public var date: Date
        public var saveStatus: AsyncStatus<Bool>

        public init(message: String = "", lang: Lang = .en, date: Date = .now, saveStatus: AsyncStatus<Bool> = .idle) {
            self.message = message
            self.lang = lang
            self.date = date
            self.saveStatus = saveStatus
        }
    }

    public enum Action: Equatable {
        case editMessage(String)
        case editLang(Lang)
        case editDate(Date)
        case save
        case saved(TaskResult<Bool>)
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
            state.saveStatus.start()
            return .task { [state] in
                let viary = Viary(
                    id: .init(rawValue: uuid().uuidString),
                    message: state.message,
                    lang: state.lang,
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
