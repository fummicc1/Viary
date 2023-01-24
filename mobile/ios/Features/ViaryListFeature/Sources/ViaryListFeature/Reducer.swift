import SwiftUI
import ComposableArchitecture
import Dependencies
import Entities
import Repositories
import IdentifiedCollections

public struct ViaryList: ReducerProtocol {

    @Dependency(\.viaryRepository) var viaryRepository

    public struct State: Equatable {
        public var viaries: IdentifiedArrayOf<Viary> = []
        public var errorMessage: String?
    }

    public enum Action: Equatable {
        case load
        case loaded(TaskResult<IdentifiedArrayOf<Viary>>)
    }

    public func reduce(into state: inout State, action: Action) -> EffectTask<Action> {
        switch action {
        case .load:
            return .task {
                do {
                    let viaries = try await viaryRepository.load()
                    return .loaded(.success(viaries))
                } catch {
                    return .loaded(.failure(error))
                }
            }
        case .loaded(let result):
            switch result {
            case .success(let viaries):
                state.viaries = viaries
            case .failure(let error):
                state.errorMessage = "\(error)"
            }
        }
        return .none
    }
}
