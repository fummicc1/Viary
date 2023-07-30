import Foundation
import RealmSwift

@MainActor
public class StoredEmotion: Object {
    @Persisted public var sentence: String = ""
    @Persisted public var score: Int = 0
    @Persisted public var kind: String = ""

    public override init() {
        super.init()
    }
}
