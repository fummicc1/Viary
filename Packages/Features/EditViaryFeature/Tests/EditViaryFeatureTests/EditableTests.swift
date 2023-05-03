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

    @MainActor
    func test_editEmotionScore() async throws {
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
            testStore.state.editable.messages[id: editMessage.id]?.emotions,
            Dictionary(
                uniqueKeysWithValues: Emotion.Kind.allCases.map {
                    (
                        $0,
                        Emotion(
                            sentence: editMessage.sentence,
                            score: 100 / Emotion.Kind.allCases.count,
                            kind: $0
                        )
                    )
                }
            )
        )

        await testStore.send(
            .editMessageEmotion(
                id: editMessage.id,
                emotionKind: editKind,
                prob: 0.8
            )
        ) {
            $0.editable.messages[id: editMessage.id]?.emotions[editKind]?.score = 80
            for kind in Emotion.Kind.allCases {
                if kind == editKind {
                    continue
                }
                $0.editable.messages[id: editMessage.id]?.emotions[kind]?.score = 20 / 6
            }

        }
    }
}
