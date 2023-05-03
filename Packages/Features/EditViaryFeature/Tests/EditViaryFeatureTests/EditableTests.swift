//
//  EditableTests.swift
//  
//
//  Created by Fumiya Tanaka on 2023/05/03.
//

import Foundation
import XCTest
import Combine
import Repositories
import Entities
import ComposableArchitecture
import Tagged
@testable import EditViaryFeature

class EditableTests: XCTestCase {

    var viaryGenerator: ViarySampleGenerator!
    let uuid = UUID()
    let now = Date.now

    override func setUp() async throws {
        try await super.setUp()
        viaryGenerator = withDependencies({
            $0.uuid = .constant(uuid)
            $0.date = .constant(now)
        }, operation: {
            ViarySampleGenerator()
        })
    }

    func editEmotionScore() async throws {
        let repository = ViaryRepositoryMock()
        let target = viaryGenerator.make()

        let testStore = TestStore(
            initialState: EditViary.State(
                original: target,
                editable: target.asDummy()
            ),
            reducer: withDependencies({
                $0.viaryRepository = repository
            }, operation: {
                EditViary()
            })
        )

        guard let editMessage = target.messages.first else {
            return XCTFail()
        }
        let editKind = Emotion.Kind.joy

        XCTAssertEqual(
            testStore.state.editable.messages[id: editMessage.id]?.emotions.values.map { $0 } ?? [],
            Emotion.Kind.allCases.map {
                Emotion(
                    sentence: editMessage.sentence,
                    score: 0,
                    kind: $0
                )
            }
        )

        await testStore.send(
            .editMessageEmotion(
                id: editMessage.id,
                emotionKind: editKind,
                score: 80
            )
        ) {
            $0.editable.messages[id: editMessage.id]?.emotions[editKind]?.score = 80
        }
    }
}
