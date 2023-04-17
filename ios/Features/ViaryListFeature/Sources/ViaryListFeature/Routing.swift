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

        var isModal: Bool {
            switch self {
            case .createViary:
                return true
            default:
                break
            }
            return false
        }


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
