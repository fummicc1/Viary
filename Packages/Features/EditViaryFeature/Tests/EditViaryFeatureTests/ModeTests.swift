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
            messages: [],
            date: date
        )
        myViaries = .init([])
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

    }
}
