import ComposableArchitecture

public struct CreateViaryReducer: ReducerProtocol {
    public struct State: Equatable {
    }

    public enum Action: Equatable {}

    public func reduce(into state: inout State, action: Action) -> EffectTask<Action> {
        .none
    }
}
