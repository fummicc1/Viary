import Combine
import Dependencies
import Entities
import Foundation
import IdentifiedCollections
import LocalDataStore
import MoyaAPIClient
import Tagged

/// @mockable
public protocol ViaryRepository {
    var myViaries: AnyPublisher<IdentifiedArrayOf<Viary>, Never> { get }

    @discardableResult
    func load() async throws -> IdentifiedArrayOf<Viary>
    func create(viary: Viary) async throws
    func create(viary: Viary, with emotions: [Viary.Message.ID: [Emotion]]) async throws
    func delete(id: Tagged<Viary, String>) async throws
}

public typealias AppAPIClient = APIClient<APIRequest>

public class ViaryRepositoryImpl {
    private let myViariesSubject: CurrentValueSubject<IdentifiedArrayOf<Viary>, Never> = .init([])
    private let apiClient: AppAPIClient
    private var cancellables: Set<AnyCancellable> = []

    public init(apiClient: AppAPIClient) {
        self.apiClient = apiClient

        Task { @MainActor in
            let stream = try StoredViary.observeAll()
            for await stored in stream.values {
                let viaries = await mapStoredIntoDomain(stored: stored)
                myViariesSubject.send(IdentifiedArrayOf(uniqueElements: viaries))
            }
        }
    }
}

extension ViaryRepositoryImpl {
    func mapStoredIntoDomain(stored: [StoredViary]) async -> [Viary] {
        await MainActor.run(body: {
            stored.map { storedViary in
                var messages: [Viary.Message] = []
                for storedMessage in storedViary.messages {
                    var message = Viary.Message(
                        viaryID: Tagged(rawValue: storedViary.id),
                        message: storedMessage.sentence,
                        lang: Lang(stringLiteral: storedMessage.lang),
                        emotions: []
                    )
                    var emotions: [Emotion] = []
                    let storedEmotions = storedMessage.emotions
                    for storedEmotion in storedEmotions {
                        guard let kind = Emotion.Kind(rawValue: storedEmotion.kind) else {
                            continue
                        }
                        let emotion = Emotion(
                            sentence: storedEmotion.sentence,
                            score: storedEmotion.score,
                            kind: kind
                        )
                        emotions.append(emotion)
                    }
                    message.emotions = emotions
                    messages.append(message)
                }
                return Viary(
                    id: .init(storedViary.id),
                    messages: messages,
                    date: storedViary.date
                )
            }
        })
    }
}

extension ViaryRepositoryImpl: ViaryRepository {
    public var myViaries: AnyPublisher<IdentifiedCollections.IdentifiedArrayOf<Entities.Viary>, Never> {
        myViariesSubject.eraseToAnyPublisher()
    }

    @discardableResult
    public func load() async throws -> IdentifiedArrayOf<Viary> {
        let latest = try await StoredViary.fetchAll()
        let viaries = await mapStoredIntoDomain(stored: latest)
        return IdentifiedArrayOf(uniqueElements: viaries)
    }

    public func create(viary: Viary) async throws {
        // TODO: Supprt multi language
        let messages = viary.messages
        let updatedAt = viary.updatedAt
        let date = viary.date
        try await Task { @MainActor in
            let newStoredViary = StoredViary()
            for message in messages {
                let storedMessage = StoredMessage()
                let resppnse: Text2EmotionResponse = try await APIRequest.text2emotion(
                    text: message.message,
                    lang: message.lang
                ).send()
                let results = resppnse.results.flatMap { $0 }
                let emotions = results.map {
                    Emotion(
                        sentence: message.message,
                        score: Int($0.score * 100.0),
                        kind: Emotion.Kind(rawValue: $0.label) ?? .unknown
                    )
                }
                storedMessage.lang = message.lang.id
                storedMessage.sentence = message.message
                storedMessage.emotions = .init()
                emotions.forEach { emotion in
                    let stored = StoredEmotion()
                    stored.kind = emotion.kind.id
                    stored.score = emotion.score
                    stored.sentence = emotion.sentence
                    storedMessage.emotions.append(stored)
                }
                newStoredViary.messages.append(storedMessage)
            }
            newStoredViary.date = date
            newStoredViary.updatedAt = updatedAt
            try await newStoredViary.create()
        }.value
    }

    public func create(viary: Viary, with emotions: [Viary.Message.ID: [Emotion]]) async throws {
        // TODO: Supprt multi language
        let messages = viary.messages
        let updatedAt = viary.updatedAt
        let date = viary.date
        try await Task { @MainActor in
            let newStoredViary = StoredViary()
            for message in messages {
                let storedMessage = StoredMessage()
                emotions[message.id]?.forEach {
                    let emotion = StoredEmotion()
                    emotion.kind = $0.kind.id
                    emotion.score = $0.score
                    emotion.sentence = $0.sentence
                    storedMessage.emotions.append(emotion)
                }
            }
            newStoredViary.date = date
            newStoredViary.updatedAt = updatedAt
            try await newStoredViary.create()
        }.value
    }

    public func delete(id: Tagged<Viary, String>) async throws {
        let predicate = NSPredicate(format: "id = %@", id.rawValue)
        let viary = try await StoredViary.fetch(by: predicate).first
        try await viary?.delete()
    }
}
