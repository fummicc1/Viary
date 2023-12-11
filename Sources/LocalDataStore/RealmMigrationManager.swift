import Foundation
import RealmSwift
import Dependencies

public protocol RealmMigrationManager: Sendable {
    func migrationMethod(migration: Migration, schemaVersion: UInt64, oldSchemaVersion: UInt64)
}

public final class RealmMigrationManagerImpl: RealmMigrationManager {

    public func migrationMethod(migration: Migration, schemaVersion: UInt64, oldSchemaVersion: UInt64) {
        if (oldSchemaVersion < schemaVersion) {
            migration.enumerateObjects(ofType: StoredEmotion.className()) { oldObject, newObject in
                // if id does not exist, assign new id.
                guard let _ = newObject?["id"] as? String else {
                    newObject?["id"] = UUID().uuidString
                    return
                }
            }
        }
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
