import Foundation
import RealmSwift
import RealmSwiftMacro

@MainActor
@GenCrud
public final class StoredMessage: Object, ObjectWithList, Sendable {
    @Persisted(primaryKey: true) public var id: String = UUID().uuidString
    @Persisted public var sentence: String = ""
    @Persisted public var lang: String = "en"
    @Persisted public var emotions: List<StoredEmotion> = .init()

    public override init() {
        super.init()
    }
}
