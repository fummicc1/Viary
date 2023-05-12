import SwiftUI
import ViaryListFeature
import CreateViaryFeature
import EditViaryFeature
import ComposableArchitecture

public struct AppScreen: View {

    let store: StoreOf<AppReducer>

    public init(store: StoreOf<AppReducer>) {
        self.store = store
    }

    public var body: some View {
        Group {
            WithViewStore(store, removeDuplicates: { $0 != $1 }) { viewStore in
                NavigationStack {
                    WithViewStore(
                        store.scope(
                            state: \.viaryList,
                            action: AppReducer.Action.viaryList
                        )
                    ) { viewStore in
                        ViaryListScreen(
                            viewStore: viewStore
                        )
                        .navigationDestination(
                            unwrapping: viewStore.binding(get: \.destination, send: { .destination($0) }),
                            case: /ViaryList.Destination.detail) { destination in
                                let viary = destination.wrappedValue
                                EditViaryScreen(
                                    store: StoreOf<EditViary>(
                                        initialState: EditViary.State(original: viary),
                                        reducer: EditViary()
                                    )
                                )
                            }
                    }
                    .background(
                        WithViewStore(
                            store.scope(state: \.createViary),
                            content: { viewStore in
                                EmptyView()
                                    .sheet(
                                        unwrapping: viewStore.binding(send: .dismissCreateViary)
                                    ) { _ in
                                        IfLetStore(
                                            store.scope(
                                                state: \.createViary,
                                                action: AppReducer.Action.createViary
                                            )
                                        ) { store in
                                            CreateViaryScreen(viewStore: ViewStoreOf<CreateViary>(store))
                                        }
                                    }
                            }
                        )
                    )
                }
            }
        }
    }
}
