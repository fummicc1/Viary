import Wireframe
import Entities

public struct CreateViaryRouting: Routing {

    public typealias Screen = CreateViaryScreen

    public typealias Input = Void

    public enum Destination {}

    public init() {}

    public func make(input: Input) -> CreateViaryScreen {
        let screen = CreateViaryScreen()
        return screen
    }
}
