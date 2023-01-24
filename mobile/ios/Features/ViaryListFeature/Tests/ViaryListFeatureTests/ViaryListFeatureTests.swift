import XCTest
import Combine
import Repositories
import Entities
import ComposableArchitecture
@testable import ViaryListFeature

final class ViaryListFeatureTests: XCTestCase {
    @MainActor
    func testLoad() async throws {
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
        
        XCTAssertEqual(viaryRepositoryMock.loadCallCount, 0)
        XCTAssertEqual(store.state.viaries, [])
        await store.send(.load)
        await store.receive(.loaded(.success(listStub))) {
            $0.viaries = listStub
        }
        XCTAssertEqual(viaryRepositoryMock.loadCallCount, 1)
    }
}

private extension ViaryListFeatureTests {
    func viaryStub() -> Viary {
        Viary(
            id: .init(UUID().uuidString),
            message: "Message",
            lang: .en,
            date: .now,
            emotions: []
        )
    }
}
