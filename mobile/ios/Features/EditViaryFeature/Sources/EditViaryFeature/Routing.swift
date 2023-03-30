import SwiftUI
import Wireframe

public struct EditViaryRouting: Routing {
    public typealias Screen = EditViaryScreen

    public typealias Input = Void

    public enum Destination {
    }

    public func make(input: Void) -> EditViaryScreen {
        EditViaryScreen()
    }
}
