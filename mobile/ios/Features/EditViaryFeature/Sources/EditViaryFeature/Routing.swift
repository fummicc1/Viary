import SwiftUI
import ComposableArchitecture
import Entities
import Wireframe

public struct EditViaryRouting: Routing {
    public typealias Screen = EditViaryScreen

    public init() {}

    public struct Input {
        public let viary: Viary

        public init(viary: Viary) {
            self.viary = viary
        }
    }

    public enum Destination {
    }

    public func make(input: Input) -> EditViaryScreen {
        EditViaryScreen(
            store: Store(
                initialState: EditViary.State(
                    original: input.viary,
                    editable: input.viary
                ),
                reducer: EditViary()
            )
        )
    }
}
