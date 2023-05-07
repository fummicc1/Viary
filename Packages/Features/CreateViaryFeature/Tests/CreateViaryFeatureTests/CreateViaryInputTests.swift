//
//  CreateViaryInputTests.swift
//  
//
//  Created by Fumiya Tanaka on 2023/02/12.
//

import XCTest
import ComposableArchitecture
import Entities
import SpeechToText
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
        let reducer = withDependencies {
            $0.speechToTextService = SpeechToTextServiceMock()
        } operation: {
            CreateViary()
        }

        store = TestStore(
            initialState: initialState,
            reducer: reducer
        )
    }

    func test_Message_edit() async throws {
        let expectedMessage = "This is what user inputted."

        XCTAssertEqual(store.state.currentInput.message, "")
        XCTAssertEqual(store.state.saveStatus, .idle)
        await store.send(.editMessage(expectedMessage)) {
            $0.currentInput.message = expectedMessage
        }
        // Assert that persist operation is not running.
        XCTAssertEqual(store.state.saveStatus, .idle)
    }

    func test_Date_edit() async throws {
        let expectedDate = Date.now

        XCTAssertEqual(store.state.date, initialState.date)
        XCTAssertEqual(store.state.saveStatus, .idle)
        await store.send(.editDate(expectedDate)) {
            $0.date = expectedDate
        }
        // Assert that persist operation is not running.
        XCTAssertEqual(store.state.saveStatus, .idle)
    }

    func test_Lang_edit() async throws {
        let expectedLang = Lang.ja
        XCTAssertEqual(store.state.currentLang, initialState.currentLang)
        XCTAssertEqual(store.state.saveStatus, .idle)
        await store.send(.editLang(expectedLang)) {
            $0.currentLang = expectedLang
        }
        // Assert that persist operation is not running.
        XCTAssertEqual(store.state.saveStatus, .idle)
    }
}
