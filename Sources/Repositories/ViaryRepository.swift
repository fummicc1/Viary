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

    func load() async throws -> IdentifiedArrayOf<Viary>
    func load(id: Viary.ID) async throws -> Viary
    func create(viary: Viary, with emotions: [Viary.Message.ID: [Emotion.Kind: Emotion]]) async throws
    func update(id: Tagged<Viary, String>, viary: Viary) async throws
    func delete(id: Tagged<Viary, String>) async throws
}

public typealias AppAPIClient = APIClient<APIRequest>

public enum ViaryRepositoryError: Error {
    case didNotFindStored(viary: Viary)
    case didNotFindStored(viaryId: Viary.ID)
}

public actor ViaryRepositoryImpl {
    private let myViariesSubject: AsyncCurrentValueSubject<IdentifiedArrayOf<Viary>> = .init([])
    private let apiClient: AppAPIClient
    private var tokens: [NotificationToken] = []

    public init(apiClient: AppAPIClient) {
        self.apiClient = apiClient

        Task {
            let (token, stream) = try await StoredViary.observe(actor: self)
            await add(token: token)
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

    private func add(token: NotificationToken) {
        tokens.append(token)
    }
}

extension ViaryRepositoryImpl {
    func mapStoredIntoDomain(stored: [StoredViary]) -> [Viary] {
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
    }
}

extension ViaryRepositoryImpl: ViaryRepository {
    nonisolated public var myViaries: AsyncStream<IdentifiedCollections.IdentifiedArrayOf<Entities.Viary>> {
        myViariesSubject.dropFirst().eraseToStream()
    }

    public func load() async throws -> IdentifiedArrayOf<Viary> {
        let latest = try await StoredViary.list()
        let viaries = mapStoredIntoDomain(stored: latest.map { $0 })
        return IdentifiedArrayOf(uniqueElements: viaries)
    }

    public func load(id: Viary.ID) async throws -> Viary {
        guard
            let target = try await StoredViary.list().first(where: { $0.id == id.rawValue }),
            let viary = mapStoredIntoDomain(stored: [target]).first else {
            assertionFailure()
            throw ViaryRepositoryError.didNotFindStored(viaryId: id)
        }
        return viary
    }

    public func create(viary: Viary, with emotions: [Viary.Message.ID: [Emotion.Kind: Emotion]]) async throws {
        let messages = viary.messages
        let updatedAt = viary.updatedAt
        let date = viary.date
        let storedMessages = {
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
        }()
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

    public func update(id: Tagged<Viary, String>, viary: Viary) async throws {
        guard let entity = try await StoredViary.list().first(where: { $0.id == id.rawValue }) else {
            assertionFailure()
            throw ViaryRepositoryError.didNotFindStored(viary: viary)
        }
        try await entity.realm?.asyncWrite({
            entity.date = viary.date
            entity.updatedAt = viary.updatedAt
            // Message
            viary.messages.forEach({ message in
                guard let stored = entity.messages.first(where: { $0.id == message.id.rawValue }) else {
                    assertionFailure()
                    return
                }
                stored.sentence = message.sentence
                stored.lang = message.lang.id
                // Emotion
                message.emotions.forEach({ (key, emotion) in
                    guard let stored = stored.emotions.first(where: { $0.kind == emotion.kind.rawValue }) else {
                        assertionFailure()
                        return
                    }
                    stored.score = emotion.score
                    stored.sentence = emotion.sentence
                })
            })
        })
    }

    public func delete(id: Tagged<Viary, String>) async throws {
        let viary = try await StoredViary.list().first(where: { $0.id == id.rawValue })
        try await viary?.delete()
    }
}
