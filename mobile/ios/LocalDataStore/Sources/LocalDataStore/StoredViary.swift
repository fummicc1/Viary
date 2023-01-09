import Foundation
import RealmSwift

public class StoredViary: Object, ObjectWithList {
    @Persisted(primaryKey: true) public var id: String = UUID().uuidString
    @Persisted public var message: String = ""
    @Published public var language: String = "en"
    @Persisted public var date: Date = Date()
    @Persisted public var emotions: List<StoredEmotion> = .init()

    public override init() {
        super.init()
    }
}

public extension StoredViary {
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

    func delete() async throws {
        let realm = try await Realm()
        try realm.write {
            realm.delete(self)
        }
    }
}
