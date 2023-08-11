import Dependencies
import Entities
import Foundation
import IdentifiedCollections
import LocalDataStore
import MoyaAPIClient
import Tagged
import AsyncExtensions

/// @mockable
public protocol ViaryRepository: Sendable {
    var myViaries: AsyncStream<IdentifiedArrayOf<Viary>> { get }

    @discardableResult
    func load() async throws -> IdentifiedArrayOf<Viary>
    func create(viary: Viary) async throws
    func create(viary: Viary, with emotions: [Viary.Message.ID: [Emotion.Kind: Emotion]]) async throws
    func update(id: Tagged<Viary, String>, viary: Viary) async throws
    func delete(id: Tagged<Viary, String>) async throws
}

public typealias AppAPIClient = APIClient<APIRequest>

public final class ViaryRepositoryImpl {
    private let myViariesSubject: AsyncCurrentValueSubject<IdentifiedArrayOf<Viary>> = .init([])
    private let apiClient: AppAPIClient

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
                        id: Tagged(storedMessage.id),
                        sentence: storedMessage.sentence,
                        lang: Lang(stringLiteral: storedMessage.lang),
                        emotions: [:]
                    )
                    var emotions: [Emotion.Kind: Emotion] = [:]
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
                        emotions[kind] = emotion
                    }
                    message.emotions = emotions
                    messages.append(message)
                }
                return Viary(
                    id: .init(storedViary.id),
                    messages: IdentifiedArray(uniqueElements: messages),
                    date: storedViary.date
                )
            }
        })
    }

    @MainActor
    func mapDomainIntoStored(id: Tagged<Viary, String>, viary: Viary, emotions: [Viary.Message.ID: [Emotion.Kind: Emotion]], canWrite: Bool = false) async throws -> StoredViary {
        let all = try await StoredViary.fetchAll()
        let storedViary: StoredViary
        var isUpdate = false
        if let cur = all.first(where: { $0.id == id.rawValue }) {
            storedViary = cur
            isUpdate = true
        } else {
            storedViary = StoredViary()
        }
        let operation = {
            if isUpdate {
                assert(storedViary.id == id.rawValue)
            }
            for message in viary.messages {
                var storedMessage: StoredMessage = .init()
                if isUpdate {
                    guard let existing = storedViary.messages.first(where: { $0.id == message.id.rawValue }) else {
                        assert(false)
                        continue
                    }
                    storedMessage = existing
                }
                storedMessage.sentence = message.sentence
                storedMessage.lang = message.lang.id
                let storedEmotions = emotions[message.id]?.compactMap { (editedEmotionKind, editedEmotion) -> StoredEmotion? in
                    var emotion = StoredEmotion()
                    if isUpdate {
                        guard let exisiting = storedMessage.emotions.first(where: { $0.kind == editedEmotionKind.id }) else {
                            assert(false)
                            return nil
                        }
                        emotion = exisiting
                    }
                    emotion.kind = editedEmotionKind.id
                    emotion.score = editedEmotion.score
                    emotion.sentence = editedEmotion.sentence
                    return emotion
                } ?? []
                storedMessage.updateListByArray(keyPath: \.emotions, array: storedEmotions)
                if isUpdate {
                    guard let i = storedViary.messages.firstIndex(where: { $0.id == message.id.rawValue }) else {
                        continue
                    }
                    storedViary.messages[i] = storedMessage
                } else {
                    storedViary.messages.append(storedMessage)
                }
            }
            storedViary.date = viary.date
            storedViary.updatedAt = viary.updatedAt
        }
        if isUpdate {
            if canWrite {
                try await storedViary.update {
                    operation()
                }
            }
        } else {
            operation()
        }
        return storedViary
    }
}

extension ViaryRepositoryImpl: ViaryRepository {
    public var myViaries: AsyncStream<IdentifiedCollections.IdentifiedArrayOf<Entities.Viary>> {
        myViariesSubject.eraseToStream()
    }

    @discardableResult
    public func load() async throws -> IdentifiedArrayOf<Viary> {
        let latest = try await StoredViary.fetchAll()
        let viaries = await mapStoredIntoDomain(stored: latest)
        return IdentifiedArrayOf(uniqueElements: viaries)
    }

    public func create(viary: Viary) async throws {
        let messages = viary.messages
        let updatedAt = viary.updatedAt
        let date = viary.date
        try await Task { @MainActor in
            let newStoredViary = StoredViary()
            for message in messages {
                let storedMessage = StoredMessage()
                storedMessage.id = message.id.rawValue
                let resppnse: Text2EmotionResponse = try await APIRequest.text2emotion(
                    text: message.sentence,
                    lang: message.lang
                ).send()
                let results = resppnse.results.flatMap { $0 }
                let emotions = results.compactMap { emotion -> Emotion? in
                    guard let kind = Emotion.Kind(rawValue: emotion.label) else {
                        return nil
                    }
                    return Emotion(
                        sentence: message.sentence,
                        score: Int(emotion.score * 100.0),
                        kind: kind
                    )
                }
                storedMessage.lang = message.lang.id
                storedMessage.sentence = message.sentence
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

    public func create(viary: Viary, with emotions: [Viary.Message.ID: [Emotion.Kind: Emotion]]) async throws {
        try await Task { @MainActor in
            let new = try await mapDomainIntoStored(id: viary.id, viary: viary, emotions: emotions)
            try await new.create()
        }.value
    }

    public func update(id: Tagged<Viary, String>, viary: Viary) async throws {
        try await Task { @MainActor in
            var emotions: [Tagged<Viary.Message, String>: [Emotion.Kind: Emotion]] = [:]
            for message in viary.messages {
                emotions[message.id] = message.emotions
            }
            _ = try await mapDomainIntoStored(id: id, viary: viary, emotions: emotions, canWrite: true)
        }.value
    }

    public func delete(id: Tagged<Viary, String>) async throws {
        let predicate = NSPredicate(format: "id = %@", id.rawValue)
        let viary = try await StoredViary.fetch(by: predicate).first
        try await viary?.delete()
    }
}
