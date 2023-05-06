import XCTest
import Combine
import Repositories
import Entities
import ComposableArchitecture
import Tagged
@testable import ViaryListFeature

final class ViaryListFeatureTests: XCTestCase {
    @MainActor
    func testLoad() async throws {
        // MARK: Assign
        let viaryRepositoryMock = ViaryRepositoryMock()
        let listStub: IdentifiedArrayOf<Viary> = []
        viaryRepositoryMock.myViariesSubject.send(listStub)
        let reducer = withDependencies {
            $0.viaryRepository = viaryRepositoryMock
        } operation: {
            ViaryList()
        }
        let store = TestStore(
            initialState: ViaryList.State(),
            reducer: reducer
        )
        // MARK: Act, Assert
        XCTAssertEqual(store.state.viaries, [])
        await store.send(.onAppear)
        await store.receive(.loaded(.success(listStub)))
        viaryRepositoryMock.myViariesSubject.send(completion: .finished)
    }

    @MainActor
    func test_create_sample() async throws {
        // MARK: Assign
        let viaryRepositoryMock = ViaryRepositoryMock()
        let now = Date.now
        let id = UUID()
        let sampleGenerator = withDependencies {
            $0.uuid = .constant(id)
            $0.date = .constant(now)
        } operation: {
            ViarySampleGenerator()
        }

        let listStub: IdentifiedArrayOf<Viary> = [sampleGenerator.make()]
        let reducer = withDependencies {
            $0.viaryRepository = viaryRepositoryMock
            $0.date = .constant(now)
            $0.viarySample = sampleGenerator
            $0.uuid = .constant(id)
        } operation: {
            ViaryList()
        }
        viaryRepositoryMock.createViaryHandler = { viary, _ in
            viaryRepositoryMock.myViariesSubject.send([viary])
        }
        let store = TestStore(
            initialState: ViaryList.State(),
            reducer: reducer
        )
        // MARK: Act, Assert
        XCTAssertEqual(store.state.viaries, [])
        await store.send(.onAppear)
        await store.receive(.loaded(.success([])))
        await store.send(.createSample)
        await store.receive(.loaded(.success(listStub))) {
            $0.viaries = listStub
        }
        viaryRepositoryMock.myViariesSubject.send(completion: .finished)
    }

    @MainActor
    func test_transit() async throws {
        // MARK: Assign
        let viaryRepositoryMock = ViaryRepositoryMock()
        let expectedDestination = ViaryList.Destination.create
        let reducer = withDependencies {
            $0.viaryRepository = viaryRepositoryMock
        } operation: {
            ViaryList()
        }
        let store = TestStore(
            initialState: ViaryList.State(),
            reducer: reducer
        )
        // MARK: Act, Assert
        XCTAssertEqual(viaryRepositoryMock.loadCallCount, 0)
        XCTAssertEqual(store.state.viaries, [])
        XCTAssertNil(store.state.destination)
        await store.send(.destination(expectedDestination)) {
            $0.destination = expectedDestination
        }
    }

    @MainActor
    func test_timeline_order() async throws {
        let viaryRepository = ViaryRepositoryMock()
        let firstDate = Date()
        let firstUUID = UUID()
        let viarySampleGenerator = withDependencies {
            $0.uuid = .constant(firstUUID)
            $0.date = .constant(firstDate)
        } operation: {
            ViarySampleGenerator()
        }
        viaryRepository.createViaryHandler = { viary, _ in
            viaryRepository.myViariesSubject.send(viaryRepository.myViariesSubject.value + [viary])
        }

        let reducer = withDependencies {
            $0.viaryRepository = viaryRepository
            $0.viarySample = viarySampleGenerator
        } operation: {
            ViaryList()
        }
        let store = TestStore(
            initialState: ViaryList.State(),
            reducer: reducer
        )
        await store.send(.onAppear)
        await store.receive(.loaded(.success([])))
        await store.send(.createSample)
        await store.receive(.loaded(.success(viaryRepository.myViariesSubject.value))) {
            $0.viaries = viaryRepository.myViariesSubject.value
        }
        let newViaryID = Tagged<Viary, String>("newViary")
        let newMessage = Viary.Message(
            viaryID: newViaryID,
            id: Tagged<Viary.Message, String>("newMessage"),
            sentence: "Sentence",
            lang: .en
        )
        let newViary = Viary(
            id: newViaryID,
            messages: [
                newMessage
            ],
            date: Date()
        )
        try await viaryRepository.create(
            viary: newViary,
            with: [
                newMessage.id: Dictionary(
                    uniqueKeysWithValues: Emotion.Kind.allCases.map { kind in
                        return (kind, Emotion(sentence: "newMessage", score: 100 / 7, kind: kind))
                    }
                )
            ]
        )
        await store.receive(.loaded(.success(viaryRepository.myViariesSubject.value))) {
            $0.viaries = viaryRepository.myViariesSubject.value
            $0.viaries = IdentifiedArray(
                uniqueElements: $0.viaries.sorted(using: KeyPathComparator(\.date)).reversed()
            )
        }
        viaryRepository.myViariesSubject.send(completion: .finished)
    }
}
