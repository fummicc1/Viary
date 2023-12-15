import SwiftUI
import ComposableArchitecture
import Dependencies
import Entities
import Repositories
import IdentifiedCollections
import Tagged

public struct ViaryList: ReducerProtocol, Sendable {

    @Dependency(\.viaryRepository) var viaryRepository
    @Dependency(\.viarySample) var viarySample

    public init() {}

    public enum Error: LocalizedError {
        case failedToCreateSample
    }

    public struct State: Equatable {
        public var viaries: Dictionary<String, [Viary]> = [:]
		public var selecteddate: Date?
		public var filteredViaries: Dictionary<String, [Viary]> {
			viaries.filter { (key, viary) in
				guard let selecteddate else {
					return true
				}
				return selecteddate.sectionable == key
			}
		}
        public var destination: Destination? = nil
        public var errorMessage: String?

        public init(
            viaries: IdentifiedArrayOf<Viary> = [],
            errorMessage: String? = nil
        ) {
            self.viaries = Dictionary(grouping: viaries, by: { viary in
				viary.date.sectionable
            })
            self.errorMessage = errorMessage
        }
    }

    public enum Action: Equatable, Sendable {
        case onAppear
        case loaded(TaskResult<IdentifiedArrayOf<Viary>>)
        case createSample
		case select(Date?)
        case didTapCreateButton
        case didTap(viary: Viary)

        case destination(Destination?)
    }

    public enum Destination: Equatable, Sendable {
        case detail(Viary.ID)
        case create
    }

    public func reduce(into state: inout State, action: Action) -> EffectTask<Action> {
        switch action {
        case .onAppear:
            return EffectTask.run { send in
                for await viaries in viaryRepository.myViaries {
                    await send(.loaded(.success(viaries)))
                }
            }
        case .loaded(let result):
            switch result {
            case .success(let viaries):
                state.viaries = Dictionary(
                    uniqueKeysWithValues: Dictionary(
                        grouping: viaries.sorted(
                            using: KeyPathComparator(
                                \.date,
                                 order: .reverse
                            )
                        ),
                        by: {
							$0.date.sectionable
                        }
                    )
                    .sorted(
                        using: KeyPathComparator(
                            \.key,
                             order: .reverse
                        )
                    ).map({
                        (
                            $0.key,
                            $0.value
                        )
                    })
                )

                if state.viaries.isEmpty {
                    return .send(.createSample)
                }
            case .failure(let error):
                state.errorMessage = "\(error)"
            }

        case .createSample:
            guard state.viaries.isEmpty else {
                state.errorMessage = Error.failedToCreateSample.localizedDescription
                return .none
            }
            return .run { _ in
                let newViary = viarySample.make()
                let emotions = Dictionary(uniqueKeysWithValues: newViary.messages.map {
                    ($0.id, $0.emotions)
                })
                try await viaryRepository.create(viary: newViary, with: emotions)
            }

		case .select(let date):
			state.selecteddate = date

        case .didTapCreateButton:
            return .send(.destination(.create))

        case let .didTap(viary):
            return .send(.destination(.detail(viary.id)))

        case .destination(let destination):
            state.destination = destination
        }
        return .none
    }
}

extension Date {
	var sectionable: String {
		"\(year)/\(month)"
	}
}
