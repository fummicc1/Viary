import SwiftUI
import RealmSwift
import LocalDataStore
import ViaryListFeature
import CreateViaryFeature
import EditViaryFeature
import ComposableArchitecture

public struct AppScreen: View {

    let store: StoreOf<AppReducer>

    @Dependency(\.realmMigrationManager) var realmMigrationManager

    public init(store: StoreOf<AppReducer>) {
        self.store = store
    }

    public var body: some View {
        Group {
            WithViewStore(
                store,
                observe: { $0 },
                removeDuplicates: { $0 != $1 }
            ) { viewStore in
                NavigationStack {
                    WithViewStore(
                        store.scope(
                            state: \.viaryList,
                            action: AppReducer.Action.viaryList
                        ),
                        observe: { $0 }
                    ) { viewStore in
                        ViaryListScreen(
                            viewStore: viewStore
                        )
                        .navigationDestination(
                            unwrapping: viewStore.binding(get: \.destination, send: { .destination($0) }),
                            case: /ViaryList.Destination.detail
                        ) { destination -> EditViaryScreen in
                            let viaryId = destination.wrappedValue
                            let state: EditViary.State
                            if let viary = viewStore.state.viaries.values.flatMap({ $0 }).first(where: { $0.id == viaryId }) {
                                state = .init(original: viary)
                            } else {
                                state = .init(originalId: viaryId)
                            }
                            return EditViaryScreen(
                                store: StoreOf<EditViary>(
                                    initialState: state,
                                    reducer: { EditViary() }
                                )
                            )
                        }
                    }
                    .background(
                        WithViewStore(
                            store.scope(
                                state: \.createViary,
                                action: { $0 }
                            ),
                            observe: { $0 },
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
                                            CreateViaryScreen(
                                                viewStore: ViewStoreOf<CreateViary>(
                                                    store,
                                                    observe: { $0 }
                                                )
                                            )
                                        }
                                    }
                            }
                        )
                    )
                }
            }
        }
        .environment(
            \.realmConfiguration,
             Realm.Configuration(
                schemaVersion: 2,
                migrationBlock: {
                    realmMigrationManager.migrationMethod(
                        migration: $0,
                        schemaVersion: 1,
                        oldSchemaVersion: $1
                    )
                }
             )
        )
    }
}
