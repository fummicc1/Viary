import Foundation
import RealmSwift

// COPY FROM https://www.mongodb.com/docs/realm/sdk/swift/actor-isolated-realm/#observe-notifications-on-an-actor-isolated-realm
actor RealmActor<DataType: Object> {
    // An implicitly-unwrapped optional is used here to let us pass `self` to
    // `Realm(actor:)` within `init`
    var realm: Realm!
    init() async throws {
        realm = try await Realm(actor: self)
    }

    var count: Int {
        realm.objects(DataType.self).count
    }

    func close() {
        realm = nil
    }

}


extension RealmActor where DataType == StoredViary {
    func create(data: StoredViary) async throws {
        try await realm.asyncWrite {
            realm.create(StoredViary.self, value: data)
        }
    }

    func update(_id: ObjectId, ) async throws {
        try await realm.asyncWrite {
            realm.create(Todo.self, value: [
                "_id": _id,
                "name": name,
                "owner": owner,
                "status": status
            ], update: .modified)
        }
    }

    func deleteTodo(todo: Todo) async throws {
        try await realm.asyncWrite {
            realm.delete(todo)
        }
    }
}
