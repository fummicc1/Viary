import Foundation
import RealmSwift
import RealmSwiftMacro

@MainActor
@GenCrud
public final class StoredEmotion: Object, Sendable {
    @Persisted(primaryKey: true) public var id: String = ObjectId.generate().stringValue
    @Persisted public var sentence: String = ""
    @Persisted public var score: Int = 0
    @Persisted public var kind: String = ""

    public override init() {
        super.init()
    }
}
