//
//  CreateViarySaveTests.swift
//  
//
//  Created by Fumiya Tanaka on 2023/02/12.
//

import XCTest
import Entities
import ComposableArchitecture
import Repositories
@testable import CreateViaryFeature

final class CreateViarySaveTests: XCTestCase {
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

    @MainActor
    func test_save() async throws {
        let expectedMessage = "expectedMessage"
        let expectedViaryEmotion: IdentifiedArrayOf<Emotion> = []
        let expectedViary = Viary(
            id: .init(
                UUIDGenerator.incrementing().uuidString
            ),
            message: expectedMessage,
            lang: .ja,
            date: Date(timeIntervalSince1970: .zero),
            emotions: expectedViaryEmotion
        )
        let initialState: CreateViary.State = .init(
            message: expectedMessage,
            lang: .ja,
            date: Date(timeIntervalSince1970: .zero)
        )
        let viaryRepositoryMock = ViaryRepositoryMock()
        viaryRepositoryMock.createHandler = { viary in
            XCTAssertEqual(expectedViary, viary)
        }
        let reducer = withDependencies {
            $0.viaryRepository = viaryRepositoryMock
            $0.uuid = .incrementing
        } operation: {
            CreateViary()
        }
        store = TestStore(
            initialState: initialState,
            reducer: reducer
        )
        // MARK: Act, Assert
        XCTAssertEqual(store.state.message, initialState.message)
        XCTAssertEqual(store.state.date, initialState.date)
        XCTAssertEqual(store.state.lang, initialState.lang)
        XCTAssertEqual(viaryRepositoryMock.createCallCount, 0)
        await store.send(.save) {
            $0.saveStatus = .loading(cache: nil)
        }
        await store.receive(.saved(.success(true))) {
            $0.saveStatus = .success(true)
        }
        XCTAssertEqual(viaryRepositoryMock.createCallCount, 1)
    }
}
