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
import EmotionDetection
import Tagged
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
            reducer: { reducer }
        )
    }

    @MainActor
    func test_save() async throws {
        let staticUUID = UUID()
        let viaryID: Tagged<Viary, String> = .init(staticUUID.uuidString)
        let messageID: Tagged<Viary.Message, String> = .init(staticUUID.uuidString)
        let expectedViaryEmotion: [Emotion.Kind: Emotion] = [
            .anger:  Emotion(sentence: "expectedMessage", score: 100, kind: .anger),
            .disgust: Emotion(sentence: "expectedMessage", score: 0, kind: .disgust),
            .fear: Emotion(sentence: "expectedMessage", score: 0, kind: .fear),
            .joy: Emotion(sentence: "expectedMessage", score: 0, kind: .joy),
            .neutral: Emotion(sentence: "expectedMessage", score: 0, kind: .neutral),
            .sadness: Emotion(sentence: "expectedMessage", score: 0, kind: .sadness),
            .surprise: Emotion(sentence: "expectedMessage", score: 0, kind: .surprise)
        ]
        let expectedMessage = Viary.Message(
            viaryID: viaryID,
            id: messageID,
            sentence: "expectedMessage",
            lang: .en,
            emotions: expectedViaryEmotion
        )
        let now = Date.now
        let initialState: CreateViary.State = .init(
            messages: [expectedMessage],
            date: now
        )
//        let viaryRepositoryMock = ViaryRepositoryMock()
        fatalError()
        let emotionDetector = EmotionDetectorMock()
        await emotionDetector.updateInferHandler(handler: { message, lang in
            expectedViaryEmotion.values.map(\.score).map { Double($0) / 100 }
        })
        let reducer = withDependencies {
//            $0.viaryRepository = viaryRepositoryMock
            $0.emotionDetector = emotionDetector
            $0.uuid = .constant(staticUUID)
        } operation: {
            CreateViary()
        }
        store = TestStore(
            initialState: initialState,
            reducer: { reducer }
        )
        // MARK: Act, Assert
        // MARK: Initial state check
        XCTAssertEqual(store.state.messages, initialState.messages)
        XCTAssertEqual(store.state.date, initialState.date)
//        XCTAssertEqual(viaryRepositoryMock.createViaryCallCount, 0)
        await store.send(.save) {
            $0.saveStatus = .loading(cache: nil)
        }
        // MARK: After saving
        await store.receive(.saved(.success(true))) {
            $0.saveStatus = .success(true)
        }
//        XCTAssertEqual(viaryRepositoryMock.createViaryCallCount, 1)
    }
}
