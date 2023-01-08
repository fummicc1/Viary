import Combine
import Entities
import Foundation
import IdentifiedCollections
import LocalDataStore
import Networking
import Tagged

public protocol ViaryRepository {
    var myViaries: AnyPublisher<IdentifiedArrayOf<Viary>, Never> { get }

    func load() async throws -> IdentifiedArrayOf<Viary>
    func create(viary: Viary) async throws
    func delete(id: Tagged<Viary, String>)
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

    public func load() async throws -> IdentifiedArrayOf<Viary> {
        let latest = try await StoredViary.fetchAll()
        let viaries = latest.map { storedViary in
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
        return IdentifiedArrayOf(uniqueElements: viaries)
    }

    public func create(viary: Viary) async throws {
        let newStoredViary = StoredViary()
        let text = viary.message
        let lang = viary.lang
        let resppnse = try await apiClient.request(with: .text2emotion(text: text, lang: lang))
    }

    public func delete(id: Tagged<Viary, String>) {

    }
}
