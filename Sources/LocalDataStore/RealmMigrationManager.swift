import RealmSwift
import Dependencies

public protocol RealmMigrationManager: Sendable {
    @discardableResult
    func configureIfNeeded(schemaVersion: UInt) -> Bool
}

public final class RealmMigrationManagerImpl: RealmMigrationManager {

    private var isConfigured: Bool = false

    public func configureIfNeeded(schemaVersion: UInt) -> Bool {
        #if DEBUG
        print("current realm schema version: \(schemaVersion)")
        #endif
        if isConfigured {
            return true
        }
        let config = Realm.Configuration(schemaVersion: UInt64(schemaVersion)) { migration, oldSchemaVersion in
            if (oldSchemaVersion < schemaVersion) {
                migration.enumerateObjects(ofType: StoredEmotion.className()) { oldObject, newObject in
                    // if id does not exist, assign new id.
                    guard let _ = newObject?["id"] as? String else {
                        newObject?["id"] = ObjectId.generate().stringValue
                        return
                    }
                }
            }
        }
        Realm.Configuration.defaultConfiguration = config
        isConfigured.toggle()
        return isConfigured
    }
}

public struct RealmMigrationManagerDepsKey: DependencyKey {
    public static var liveValue: RealmMigrationManager = RealmMigrationManagerImpl()
}

extension DependencyValues {
    public var realmMigrationManager: any RealmMigrationManager {
        get {
            self[RealmMigrationManagerDepsKey.self]
        }
        set {
            self[RealmMigrationManagerDepsKey.self] = newValue
        }
    }
}
