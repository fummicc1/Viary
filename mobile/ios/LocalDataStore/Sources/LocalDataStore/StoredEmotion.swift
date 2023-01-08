import Foundation
import RealmSwift

public class StoredEmotion: Object {
    @Persisted public var sentence: String = ""
    @Persisted public var score: Int = 0
    @Persisted public var kinds: List<String> = .init()

    public override init() {
        super.init()
    }
}
