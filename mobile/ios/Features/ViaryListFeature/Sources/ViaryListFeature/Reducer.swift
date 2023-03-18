import SwiftUI
import ComposableArchitecture
import Dependencies
import Entities
import Repositories
import IdentifiedCollections
import Tagged

public struct ViaryList: ReducerProtocol {

    @Dependency(\.viaryRepository) var viaryRepository

    public init() {}

    public enum Error: LocalizedError {
        case failedToCreateSample
    }

    public struct State: Equatable {
        public var viaries: IdentifiedArrayOf<Viary> = []
        public var errorMessage: String?
        public var destination: Destination?

        public init(
            viaries: IdentifiedArrayOf<Viary> = [],
            destination: Destination? = nil,
            errorMessage: String? = nil
        ) {
            self.viaries = viaries
            self.destination = destination
            self.errorMessage = errorMessage
        }
    }

    public enum Action: Equatable {
        case load
        case loaded(TaskResult<IdentifiedArrayOf<Viary>>)
        case createSample
        case transit(Destination?)
    }

    public func reduce(into state: inout State, action: Action) -> EffectTask<Action> {
        switch action {
        case .load:
            return .task {
                do {
                    var viaries = try await viaryRepository.load()
                    viaries.sort(using: KeyPathComparator(\.updatedAt))
                    viaries.reverse()
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

        case .createSample:
            guard state.viaries.isEmpty else {
                state.errorMessage = Error.failedToCreateSample.localizedDescription
                return .none
            }
            return .task {
                let newViary = Viary.sample()
                try await viaryRepository.create(viary: newViary)
                return .load
            }

        case .transit(let destination):
            state.destination = destination
        }
        return .none
    }
}
