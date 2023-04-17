import ComposableArchitecture
import Entities
import Wireframe

public struct CreateViaryRouting: Routing {

    public typealias Screen = CreateViaryScreen

    public typealias Input = Void

    public enum Destination {}

    public init() {}

    public func make(input: Input) -> CreateViaryScreen {
        let store = Store(
            initialState: CreateViary.State(),
            reducer: CreateViary()
        )
        let screen = CreateViaryScreen(store: store)
        return screen
    }
}
