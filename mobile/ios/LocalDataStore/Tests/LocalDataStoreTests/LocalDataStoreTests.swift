import XCTest
@testable import LocalDataStore

final class LocalDataStoreTests: XCTestCase {
    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(LocalDataStore().text, "Hello, World!")
    }
}
