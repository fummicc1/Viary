import Foundation
import RealmSwift
import RealmSwiftMacro

@GenCrud
public final class StoredEmotion: Object {
    @Persisted(primaryKey: true) public var id: String = UUID().uuidString
    @Persisted public var sentence: String = ""
    @Persisted public var score: Int = 0
    @Persisted public var kind: String = ""

    public override init() {
        super.init()
    }
}
