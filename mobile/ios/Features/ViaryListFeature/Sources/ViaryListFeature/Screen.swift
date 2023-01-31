import Foundation
import Entities
import ComposableArchitecture
import FloatingActionButton
import SwiftUI
import SwiftUINavigation

public struct ViaryListScreen: View {
    let store: StoreOf<ViaryList>

    @Dependency(\.router) var router

    public init(store: StoreOf<ViaryList>) {
        self.store = store
    }

    public var body: some View {
        WithViewStore(store) { viewStore in
            Group {
                let viaries = viewStore.viaries
                if viaries.isEmpty {
                    Button {
                        viewStore.send(.createSample)
                    } label: {
                        Text("Create")
                    }
                    .buttonStyle(.borderedProminent)
                } else {
                    FloatingActionable(
                        .bottomTrailing,
                        fab: .image(Image(systemName: "plus"))
                    ) {
                        list
                    } didPress: {
                        viewStore.send(.transit(.createViary))
                    }
                }
            }
            .sheet(unwrapping: viewStore.binding(get: \.destination, send: { .transit($0) }), content: { destination in
                router.destinate(ViaryList.self, destination: destination.wrappedValue)
            })
            .task {
                viewStore.send(.load)
            }
        }
    }

    var list: some View {
        WithViewStore(store, observe: \.viaries) { viewStore in
            List {
                ForEach(viewStore.state) { viary in
                    VStack {
                        Text(viary.message)
                        HStack {
                            Text(viary.date, style: .relative)
                                .foregroundColor(.secondary)
                            Spacer()
                        }
                    }
                }
            }
        }
    }
}
