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
    func delete(id: Tagged<Viary, String>) async throws
}

public typealias AppAPIClient = any APIClient<APIRequest>

public class ViaryRepositoryImpl {
    private let myViariesSubject: CurrentValueSubject<IdentifiedArrayOf<Viary>, Never> = .init([])
    private let apiClient: AppAPIClient

    public init(apiClient: AppAPIClient) {
        self.apiClient = apiClient
    }
}

extension ViaryRepositoryImpl: ViaryRepository {
    public var myViaries: AnyPublisher<IdentifiedCollections.IdentifiedArrayOf<Entities.Viary>, Never> {
        myViariesSubject.eraseToAnyPublisher()
    }

    @discardableResult
    public func load() async throws -> IdentifiedArrayOf<Viary> {
        let latest = try await StoredViary.fetchAll()
        let viaries = await MainActor.run(body: {
            latest.map { storedViary in
               let emotions: [Emotion] = Array(storedViary.emotions.compactMap { storedEmotion in
                   guard let kind = Emotion.Kind(rawValue: storedEmotion.kind) else {
                       return nil
                   }
                   return Emotion(
                       sentence: storedEmotion.sentence,
                       score: storedEmotion.score,
                       kind: kind
                   )
               })
               return Viary(
                   id: .init(storedViary.id),
                   message: storedViary.message,
                   lang: Lang(stringLiteral: storedViary.language),
                   date: storedViary.date,
                   emotions: .init(uniqueElements: emotions)
               )
           }
        })
        return IdentifiedArrayOf(uniqueElements: viaries)
    }

    public func create(viary: Viary) async throws {
        let message = viary.message
        let lang = viary.lang
        let date = viary.date
        let resppnse: Text2EmotionResponse = try await apiClient.request(with: .text2emotion(text: message, lang: lang))
        let results = resppnse.results.flatMap { $0 }
        Task { @MainActor in
            let newStoredViary = StoredViary()
            newStoredViary.language = lang.rawValue
            newStoredViary.message = message
            newStoredViary.date = date
            let emotions = results.map({ result in
                let emotion = StoredEmotion()
                emotion.kind = result.label
                emotion.score = Int(result.score * 100)
                emotion.sentence = message
                return emotion
            })
            newStoredViary.updateListByArray(keyPath: \.emotions, array: emotions)
            try await newStoredViary.create()
        }
    }

    public func delete(id: Tagged<Viary, String>) async throws {
        let predicate = NSPredicate(format: "id = %@", id.rawValue)
        let viary = try await StoredViary.fetch(by: predicate).first
        try await viary?.delete()
    }
}
