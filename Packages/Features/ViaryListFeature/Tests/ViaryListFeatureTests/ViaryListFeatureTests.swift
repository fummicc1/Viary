import XCTest
import Combine
import Repositories
import Entities
import ComposableArchitecture
import Tagged
@testable import ViaryListFeature

final class ViaryListFeatureTests: XCTestCase {
    @MainActor
    func testLoad() async throws {
        // MARK: Assign
        let viaryRepositoryMock = ViaryRepositoryMock()
        let listStub: IdentifiedArrayOf<Viary> = [viaryStub()]
        viaryRepositoryMock.loadHandler = { listStub }
        let reducer = withDependencies {
            $0.viaryRepository = viaryRepositoryMock
        } operation: {
            ViaryList()
        }
        let store = TestStore(
            initialState: ViaryList.State(),
            reducer: reducer
        )
        // MARK: Act, Assert
        XCTAssertEqual(viaryRepositoryMock.loadCallCount, 0)
        XCTAssertEqual(store.state.viaries, [])
        await store.send(.onAppear)
        await store.receive(.loaded(.success(listStub))) {
            $0.viaries = listStub
        }
        XCTAssertEqual(viaryRepositoryMock.loadCallCount, 1)
    }

    @MainActor
    func test_create_sample() async throws {
        // MARK: Assign
        let viaryRepositoryMock = ViaryRepositoryMock()
        let listStub: IdentifiedArrayOf<Viary> = [Viary.sample()]
        viaryRepositoryMock.loadHandler = {
            listStub
        }
        let reducer = withDependencies {
            $0.viaryRepository = viaryRepositoryMock
        } operation: {
            ViaryList()
        }
        let store = TestStore(
            initialState: ViaryList.State(),
            reducer: reducer
        )
        // MARK: Act, Assert
        XCTAssertEqual(viaryRepositoryMock.loadCallCount, 0)
        XCTAssertEqual(store.state.viaries, [])
        await store.send(.createSample)
        await store.receive(.onAppear)
        await store.receive(.loaded(.success(listStub))) {
            $0.viaries = listStub
        }
        XCTAssertEqual(viaryRepositoryMock.loadCallCount, 1)
    }

    @MainActor
    func test_transit() async throws {
        // MARK: Assign
        let viaryRepositoryMock = ViaryRepositoryMock()
        let expectedDestination = ViaryList.Destination.create
        let reducer = withDependencies {
            $0.viaryRepository = viaryRepositoryMock
        } operation: {
            ViaryList()
        }
        let store = TestStore(
            initialState: ViaryList.State(),
            reducer: reducer
        )
        // MARK: Act, Assert
        XCTAssertEqual(viaryRepositoryMock.loadCallCount, 0)
        XCTAssertEqual(store.state.viaries, [])
        XCTAssertNil(store.state.destination)
        await store.send(.destination(expectedDestination)) {
            $0.destination = expectedDestination
        }
    }
}

private extension ViaryListFeatureTests {
    func viaryStub() -> Viary {
        let id: Tagged<Viary, String> = .init(UUID().uuidString)
        return Viary(
            id: id,
            messages: [
                Viary.Message(
                    viaryID: id,
                    id: .init(UUID().uuidString),
                    sentence: "",
                    lang: .en
                )
            ],
            date: .now
        )
    }
}
