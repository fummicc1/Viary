import Foundation
import RealmSwift

@MainActor
public class StoredMessage: Object {
    @Persisted(primaryKey: true) public var id: String = UUID().uuidString
    @Persisted public var sentence: String = ""
    @Persisted public var lang: String = "en"
    @Persisted public var emotions: List<StoredEmotion> = .init()

    public override init() {
        super.init()
    }
}
