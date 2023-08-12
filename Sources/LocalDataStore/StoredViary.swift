import Foundation
import RealmSwift
import Combine

@MainActor
public class StoredViary: Object, ObjectWithList {
    @Persisted(primaryKey: true) public var id: String = UUID().uuidString
    @Persisted public var messages: List<StoredMessage> = .init()
    @Persisted public var date: Date = Date()
    @Persisted public var updatedAt: Date = Date()

    public override init() {
        super.init()
    }
}

@MainActor
public extension StoredViary {
    static func observeAll() async throws -> AsyncStream<[StoredViary]> {
        let realm = try  Realm()
        let list = await realm.objects(StoredViary.self)

            .collectionPublisher
            .map { Array($0) }
            .replaceError(with: [])
            .eraseToAnyPublisher()
    }

    static func fetchAll() async throws -> [StoredViary] {
        let realm = try await Realm()
        let viaries = Array(realm.objects(StoredViary.self))
        return viaries
    }

    static func fetch(by predicate: NSPredicate) async throws -> [StoredViary] {
        let realm = try await Realm()
        return Array(realm.objects(StoredViary.self).filter(predicate))
    }

    func create() async throws {
        let realm = try await Realm()
        try realm.write {
            realm.add(self)
        }
    }

    func update(_ handler: @escaping () -> Void) async throws {
        let realm = try await Realm()
        try realm.write {
            handler()
        }
    }

    func delete() async throws {
        let realm = try await Realm()
        try realm.write {
            realm.delete(self)
        }
    }
}
