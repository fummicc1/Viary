//
//  ModeTests.swift
//  
//
//  Created by Fumiya Tanaka on 2023/05/13.
//

import XCTest
import ComposableArchitecture
import Tagged
import Entities
import Repositories
import Combine

@testable import EditViaryFeature

final class ModeTests: XCTestCase {

    var myViaries = CurrentValueSubject<IdentifiedArrayOf<Viary>, Never>([])

    override func setUpWithError() throws {
    }

    override func tearDownWithError() throws {
    }

    @MainActor
    func test_viewMode() async throws {
        let uuid = UUID()
        let date = Date.now
        let repository = ViaryRepositoryMock()
        let baseViary = Viary(
            id: Tagged<Viary, String>(uuid.uuidString),
            messages: [
                Viary.Message(
                    viaryID: Tagged<Viary, String>(uuid.uuidString),
                    id: Tagged<Viary.Message, String>(uuid.uuidString),
                    sentence: "Hello",
                    lang: .en
                )
            ],
            date: date
        )
        myViaries = .init([baseViary])
        repository.myViaries = myViaries.eraseToAnyPublisher()
        let store = TestStore(
            initialState: EditViary.State(
                original: baseViary
            ),
            reducer: withDependencies({
                $0.uuid = .constant(uuid)
                $0.date = .constant(date)
            }, operation: {
                EditViary()
            })
        )
        XCTAssertEqual(store.state.mode, EditViary.Mode.view)
        await store.send(
            .editMessageSentence(
                id: baseViary.messages.first!.id,
                sentence: "Hello!!"
            )
        )
        await store.send(.toggleMode) {
            $0.mode = .edit
        }
        await store.send(
            .editMessageSentence(
                id: baseViary.messages.first!.id,
                sentence: "Hello!!"
            )
        ) {
            let id: Tagged<Viary.Message, String> = Tagged(uuid.uuidString)
            $0.editable.messages[id: id]?.sentence = "Hello!!"
            $0.resolved[id] = false
        }
    }

    override func tearDown() {
        super.tearDown()
        myViaries.send(completion: .finished)
    }
}
