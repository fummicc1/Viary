import Wireframe
import Entities
import ComposableArchitecture
import SwiftUI

extension ViaryList: Routing {
    public typealias Screen = ViaryListScreen
    public struct Input {
    }
    public enum Destination: Equatable {
        case createViary
        case viaryDetail(Viary)
    }

    public func make(input: Input) -> ViaryListScreen {
        ViaryListScreen(
            store: Store<ViaryList.State, ViaryList.Action>(
                initialState: .init(),
                reducer: ViaryList()
            )
        )
    }
}
