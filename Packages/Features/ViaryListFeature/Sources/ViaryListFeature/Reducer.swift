import SwiftUI
import Combine
import ComposableArchitecture
import Dependencies
import Entities
import Repositories
import IdentifiedCollections
import Tagged

public struct ViaryList: ReducerProtocol {

    @Dependency(\.viaryRepository) var viaryRepository
    @Dependency(\.viarySample) var viarySample

    public init() {}

    public enum Error: LocalizedError {
        case failedToCreateSample
    }

    public struct State: Equatable {
        public var viaries: IdentifiedArrayOf<Viary> = []
        public var destination: Destination? = nil
        public var errorMessage: String?

        var streamCancellable: AnyCancellable?

        public init(
            viaries: IdentifiedArrayOf<Viary> = [],
            errorMessage: String? = nil
        ) {
            self.viaries = viaries
            self.errorMessage = errorMessage
        }
    }

    public enum Action: Equatable {
        case onAppear
        case loaded(TaskResult<IdentifiedArrayOf<Viary>>)
        case createSample
        case didTapCreateButton
        case didTap(viary: Viary)

        case destination(Destination?)
    }

    public enum Destination: Equatable {
        case detail(Viary)
        case create
    }

    public func reduce(into state: inout State, action: Action) -> EffectTask<Action> {
        switch action {
        case .onAppear:
            return EffectTask.publisher {
                viaryRepository.myViaries.map { Action.loaded(.success($0)) }
            }
        case .loaded(let result):
            switch result {
            case .success(let viaries):
                state.viaries = IdentifiedArray(
                    uniqueElements: viaries.sorted(using: KeyPathComparator(\.date)).reversed()
                )
            case .failure(let error):
                state.errorMessage = "\(error)"
            }

        case .createSample:
            guard state.viaries.isEmpty else {
                state.errorMessage = Error.failedToCreateSample.localizedDescription
                return .none
            }
            return .fireAndForget {
                let newViary = viarySample.make()
                let emotions = Dictionary(uniqueKeysWithValues: newViary.messages.map {
                    ($0.id, $0.emotions)
                })
                try await viaryRepository.create(viary: newViary, with: emotions)
            }

        case .didTapCreateButton:
            return .send(.destination(.create))

        case let .didTap(viary):
            return .send(.destination(.detail(viary)))

        case .destination(let destination):
            state.destination = destination
        }
        return .none
    }
}
