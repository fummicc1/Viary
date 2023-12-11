import RealmSwift
import Foundation

public protocol ObjectWithList {}

public extension ObjectWithList where Self: Object {
    func updateListByArray<E: RealmCollectionValue>(keyPath: ReferenceWritableKeyPath<Self, List<E>>, array: Array<E>) {
        let list = List<E>()
        list.append(objectsIn: array)
        self[keyPath: keyPath] = list
    }
}
