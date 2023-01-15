import XCTest
import ComposableArchitecture
@testable import ViaryListFeature

final class ViaryListFeatureTests: XCTestCase {
    func testExample() throws {
        let store = TestStore(
            initialState: ViaryListState(),
            reducer: viaryListReducer,
            environment: ViaryListEnv(viaryRepository: )
        )
    }
}
