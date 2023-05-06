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
        let listStub: IdentifiedArrayOf<Viary> = []
        viaryRepositoryMock.myViariesSubject.send(listStub)
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
        XCTAssertEqual(store.state.viaries, [])
        await store.send(.onAppear)
        await store.receive(.loaded(.success(listStub)))
        viaryRepositoryMock.myViariesSubject.send(completion: .finished)
    }

    @MainActor
    func test_create_sample() async throws {
        // MARK: Assign
        let viaryRepositoryMock = ViaryRepositoryMock()
        let now = Date.now
        let id = UUID()
        let sampleGenerator = withDependencies {
            $0.uuid = .constant(id)
            $0.date = .constant(now)
        } operation: {
            ViarySampleGenerator()
        }

        let listStub: IdentifiedArrayOf<Viary> = [sampleGenerator.make()]
        let reducer = withDependencies {
            $0.viaryRepository = viaryRepositoryMock
            $0.date = .constant(now)
            $0.viarySample = sampleGenerator
            $0.uuid = .constant(id)
        } operation: {
            ViaryList()
        }
        viaryRepositoryMock.createViaryHandler = { viary, _ in
            viaryRepositoryMock.myViariesSubject.send([viary])
        }
        let store = TestStore(
            initialState: ViaryList.State(),
            reducer: reducer
        )
        // MARK: Act, Assert
        XCTAssertEqual(store.state.viaries, [])
        await store.send(.onAppear)
        await store.receive(.loaded(.success([])))
        await store.send(.createSample)
        await store.receive(.loaded(.success(listStub))) {
            $0.viaries = listStub
        }
        viaryRepositoryMock.myViariesSubject.send(completion: .finished)
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

    @MainActor
    func test_timeline_order() async throws {
        let viaryRepository = ViaryRepositoryMock()
        let reducer = ViaryList().transformDependency(\.self) {
            $0.viaryRepository = viaryRepository
        }
        let store = TestStore(
            initialState: ViaryList.State(),
            reducer: reducer
        )
        await store.send(.onAppear)
    }
}
