import Foundation
import RealmSwift
import RealmSwiftMacro

@MainActor
@GenCrud
public final class StoredEmotion: Object, Sendable {
    @Persisted public var sentence: String = ""
    @Persisted public var score: Int = 0
    @Persisted public var kind: String = ""

    public override init() {
        super.init()
    }
}
