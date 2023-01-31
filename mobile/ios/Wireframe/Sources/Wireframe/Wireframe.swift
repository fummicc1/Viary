import SwiftUI
import XCTestDynamicOverlay
import Dependencies
import UIKit

public protocol Router {
    func destinate<S: Routing>(_ routing: S.Type, destination: S.Destination) -> AnyView
}

public struct RouterKey: DependencyKey {
    public static var liveValue: Router = unimplemented()
}

extension DependencyValues {
    public var router: Router {
        get {
            self[RouterKey.self]
        } set {
            self[RouterKey.self] = newValue
        }
    }
}

public protocol Routing {
    associatedtype Screen: View
    associatedtype Input
    associatedtype Destination
    func make(input: Input) -> Screen
}
