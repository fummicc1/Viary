import Foundation
import RealmSwift
import Combine
import RealmSwiftMacro

@MainActor
@GenCrud
public class StoredViary: Object, ObjectWithList {
    @Persisted(primaryKey: true) public var id: String = UUID().uuidString
    @Persisted public var messages: List<StoredMessage> = .init()
    @Persisted public var date: Date = Date()
    @Persisted public var updatedAt: Date = Date()

    public override init() {
        super.init()
    }
}
