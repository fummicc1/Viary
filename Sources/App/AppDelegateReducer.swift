import Foundation
import FirebaseCore
import FirebaseAnalytics
import ComposableArchitecture

public struct AppDelegateReducer: Reducer {
    public struct State: Equatable {
        public init() {}
    }

    public enum Action {
        case didFinishLaunching
    }

    public func reduce(into state: inout State, action: Action) -> Effect<Action> {
        switch action {
        case .didFinishLaunching:
            FirebaseApp.configure()
        }
        return .none
    }
}
