import Foundation
import RealmSwift
import RealmSwiftMacro

@MainActor
@GenCrud
public final class StoredViary: Object, ObjectWithList, Sendable {
    @Persisted(primaryKey: true) public var id: String = ObjectId.generate().stringValue
    @Persisted public var messages: List<StoredMessage> = .init()
    @Persisted public var date: Date = Date()
    @Persisted public var updatedAt: Date = Date()

    public override init() {
        super.init()
    }
}
