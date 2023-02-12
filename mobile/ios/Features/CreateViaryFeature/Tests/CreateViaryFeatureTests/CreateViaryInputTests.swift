//
//  CreateViaryInputTests.swift
//  
//
//  Created by Fumiya Tanaka on 2023/02/12.
//

import XCTest
import ComposableArchitecture
import Entities
@testable import CreateViaryFeature

final class CreateViaryInputTests: XCTestCase {

    var store: TestStore<
        CreateViary.State,
        CreateViary.Action,
        CreateViary.State,
        CreateViary.Action,
        Void
    >!
    let initialState: CreateViary.State = .init(
        date: Date(timeIntervalSince1970: .zero)
    )

    override func setUpWithError() throws {
        let reducer = CreateViary()
        store = TestStore(
            initialState: initialState,
            reducer: reducer
        )
    }

    func test_Message_edit() async throws {
        let expectedMessage = "This is what user inputted."

        XCTAssertEqual(store.state.message, "")
        XCTAssertEqual(store.state.saveStatus, .idle)
        await store.send(.editMessage(expectedMessage)) {
            $0.message = expectedMessage
        }
        XCTAssertEqual(store.state.saveStatus, .idle)
    }

    func test_Date_edit() async throws {
        let expectedDate = Date.now

        XCTAssertEqual(store.state.date, initialState.date)
        XCTAssertEqual(store.state.saveStatus, .idle)
        await store.send(.editDate(expectedDate)) {
            $0.date = expectedDate
        }
        XCTAssertEqual(store.state.saveStatus, .idle)
    }

    func test_Lang_edit() async throws {
        let expectedLang = Lang.ja
        XCTAssertEqual(store.state.lang, initialState.lang)
        XCTAssertEqual(store.state.saveStatus, .idle)
        await store.send(.editLang(expectedLang)) {
            $0.lang = expectedLang
        }
        XCTAssertEqual(store.state.saveStatus, .idle)
    }
}
