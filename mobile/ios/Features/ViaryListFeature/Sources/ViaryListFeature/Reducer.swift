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

        public init(viaries: IdentifiedArrayOf<Viary> = [], errorMessage: String? = nil) {
            self.viaries = viaries
            self.errorMessage = errorMessage
        }
    }

    public enum Action: Equatable {
        case load
        case loaded(TaskResult<IdentifiedArrayOf<Viary>>)
        case createSample
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

        case .createSample:
            guard state.viaries.isEmpty else {
                state.errorMessage = Error.failedToCreateSample.localizedDescription
                return .none
            }
            return .task {
                let newViary = Viary(
                    id: Tagged<Viary, String>.uuid,
                    message: "This is sample viary!",
                    lang: .en,
                    date: .now,
                    emotions: []
                )
                try await viaryRepository.create(viary: newViary)
                return .load
            }
        }
        return .none
    }
}

private extension Tagged where RawValue == String {
    static var uuid: Self {
        Self(UUID().uuidString)
    }
}
