import Foundation
import FirebaseCore
import FirebaseAnalytics
import ComposableArchitecture

public struct AppDelegateReducer: ReducerProtocol {
    public struct State: Equatable {
        public init() {}
    }

    public enum Action {
        case didFinishLaunching
    }

    public func reduce(into state: inout State, action: Action) -> EffectTask<Action> {
        switch action {
        case .didFinishLaunching:
            FirebaseApp.configure()
        }
        return .none
    }
}
