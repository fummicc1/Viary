import Dependencies
import Entities
import Foundation
import IdentifiedCollections
import LocalDataStore
import MoyaAPIClient
import Tagged
import AsyncExtensions
import RealmSwift

/// @mockable
public protocol ViaryRepository: Sendable {
    var myViaries: AsyncStream<IdentifiedArrayOf<Viary>> { get }

    @discardableResult
    func load() async throws -> IdentifiedArrayOf<Viary>
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
            let initialEntities = try await StoredViary.list()
            let initialDomain = await mapStoredIntoDomain(stored: initialEntities.map { $0 })
            myViariesSubject.send(IdentifiedArrayOf(uniqueElements: initialDomain))
            let stream = try await StoredViary.observe()
            var domainViaries: [Viary] = []
            for await changes in stream {
                switch changes {
                case let .update(
                    stored,
                    deletions: _,
                    insertions: _,
                    modifications: _
                ):
                    domainViaries = await mapStoredIntoDomain(stored: stored.map { $0 })
                case .initial(let initialViaries):
                    domainViaries = await mapStoredIntoDomain(stored: initialViaries.map { $0 })
                case .error(let error):
                    #if DEBUG
                    print("error:", error)
                    #endif
                }
                myViariesSubject.send(IdentifiedArrayOf(uniqueElements: domainViaries))
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
    func mapDomainIntoStored(
        id: Tagged<Viary, String>,
        viary: Viary
    ) async throws -> StoredViary {
        let all = try await StoredViary.list()
        return all.first(where: { $0.id == id.rawValue }) ?? StoredViary()
    }
}

extension ViaryRepositoryImpl: ViaryRepository {
    public var myViaries: AsyncStream<IdentifiedCollections.IdentifiedArrayOf<Entities.Viary>> {
        myViariesSubject.eraseToStream()
    }

    @discardableResult
    public func load() async throws -> IdentifiedArrayOf<Viary> {
        let latest = try await StoredViary.list()
        let viaries = await mapStoredIntoDomain(stored: latest.map { $0 })
        return IdentifiedArrayOf(uniqueElements: viaries)
    }

    public func create(viary: Viary, with emotions: [Viary.Message.ID: [Emotion.Kind: Emotion]]) async throws {
        let messages = viary.messages
        let updatedAt = viary.updatedAt
        let date = viary.date
        let storedMessages = await Task { @MainActor in
            let list = List<StoredMessage>()
            for message in messages {
                let storedMessage = StoredMessage()
                storedMessage.id = message.id.rawValue
                storedMessage.lang = message.lang.id
                storedMessage.sentence = message.sentence
                storedMessage.emotions = .init()
                emotions[message.id]?.forEach { (kind, emotion) in
                    let stored = StoredEmotion()
                    stored.kind = kind.id
                    stored.score = emotion.score
                    stored.sentence = emotion.sentence
                    storedMessage.emotions.append(stored)
                }
                list.append(storedMessage)
            }
            return list
        }.value
        do {
            _ = try await StoredViary.create(
                id: viary.id.rawValue,
                messages: storedMessages,
                date: date,
                updatedAt: updatedAt
            )
        } catch {
            #if DEBUG
            print(error)
            #endif
        }
    }

    @MainActor
    public func update(id: Tagged<Viary, String>, viary: Viary) async throws {
        let stored = try await StoredViary.list().first(where: { $0.id == id.rawValue })
        guard let stored else {
            return
        }
        try await stored.update(
            date: viary.date,
            updatedAt: viary.updatedAt
        )
        for message in viary.messages {
            guard let storedMessage = try await StoredMessage.list().first(where: { $0.id == message.id.rawValue }) else {
                continue
            }
            try await storedMessage.update(
                sentence: message.sentence,
                lang: message.lang.id
            )
            for (kind, emotion) in message.emotions {
                guard let storedEmotion = storedMessage.emotions.first(where: { $0.kind == kind.id }) else {
                    continue
                }
                try await storedEmotion.update(
                    sentence: message.sentence,
                    score: emotion.score,
                    kind: kind.id
                )
            }
        }
    }

    @MainActor
    public func delete(id: Tagged<Viary, String>) async throws {
        let viary = try await StoredViary.list().first(where: { $0.id == id.rawValue })
        try await viary?.delete()
    }
}
