import SwiftUI
import ComposableArchitecture
import Dependencies
import Entities
import Repositories
import IdentifiedCollections

public struct ViaryListState: Equatable {
    public var viaries: IdentifiedArrayOf<Viary> = []
    public var errorMessage: String?
}

public enum ViaryListAction {
    case load
    case loaded(Result<IdentifiedArrayOf<Viary>, Error>)
}

public struct ViaryListEnv {
    public let viaryRepository: ViaryRepository

    public init(viaryRepository: ViaryRepository) {
        self.viaryRepository = viaryRepository
    }
}

public let viaryListReducer: Reducer<ViaryListState, ViaryListAction, ViaryListEnv> = .init { state, action, env in
    switch action {
    case .load:
        return .task {
            do {
                let viaries = try await env.viaryRepository.load()
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
