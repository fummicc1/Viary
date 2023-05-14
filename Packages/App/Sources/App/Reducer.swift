import ComposableArchitecture
import CreateViaryFeature
import EditViaryFeature
import ViaryListFeature

public struct AppReducer: ReducerProtocol {
    public struct State: Equatable {
        public var appDelegate: AppDelegateReducer.State
        public var createViary: CreateViary.State?
        public var editViary: EditViary.State?
        public var viaryList: ViaryList.State

        public init(
            appDelegate: AppDelegateReducer.State = .init(),
            createViary: CreateViary.State? = nil,
            editViary: EditViary.State? = nil,
            viaryList: ViaryList.State = .init()
        ) {
            self.appDelegate = appDelegate
            self.createViary = createViary
            self.editViary = editViary
            self.viaryList = viaryList
        }
    }

    public enum Action: Equatable {
        case appDelegate(AppDelegateReducer.Action)

        case createViary(CreateViary.Action)
        case editViary(EditViary.Action)
        case viaryList(ViaryList.Action)

        case dismissCreateViary
        case dismissEditViary
    }

    public init() { }

    @ReducerBuilder<State, Action>
    public var body: some ReducerProtocol<State, Action> {
        Scope(state: \.appDelegate, action: /Action.appDelegate) {
            AppDelegateReducer()
        }
        Scope(
            state: \.viaryList,
            action: /Action.viaryList
        ) {
            ViaryList()
        }
        .ifLet(\.createViary, action: /Action.createViary) {
            CreateViary()
        }
        .ifLet(\.editViary, action: /Action.editViary) {
            EditViary()
        }
        Reduce { state, action in
            switch action {
            case let .viaryList(destination):
                switch destination {
                case .didTapCreateButton:
                    state.createViary = .init()
                case let .didTap(viary):
                    state.editViary = .init(original: viary)
                default:
                    break
                }
            case .dismissEditViary:
                state.editViary = nil
            case .dismissCreateViary:
                state.createViary = nil
            default:
                break
            }
            return .none
        }
    }
}
