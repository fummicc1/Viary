import Foundation
import Entities
import ComposableArchitecture
import FloatingActionButton
import SwiftUI
import SharedUI
import SwiftUINavigation

public struct ViaryListScreen: View {
    let store: StoreOf<ViaryList>

    @Dependency(\.router) var router

    public init(store: StoreOf<ViaryList>) {
        self.store = store
    }

    public var body: some View {
        WithViewStore(store) { viewStore in
            content(viewStore)
                .navigationDestination(
                    unwrapping: viewStore.binding(
                        get: {
                            if case /ViaryList.Destination.viaryDetail = $0.destination {
                                return $0.destination
                            }
                            return nil
                        },
                        send: { .transit($0) }
                    ),
                    destination: { destination in
                        router.destinate(ViaryList.self, destination: destination.wrappedValue)
                    }
                )
                .fullScreenCover(
                    unwrapping: viewStore.binding(
                        get: {
                            if case /ViaryList.Destination.createViary = $0.destination {
                                return $0.destination
                            }
                            return nil
                        },
                        send: { .transit($0) }
                    ),
                    content: { destination in
                        router.destinate(ViaryList.self, destination: destination.wrappedValue)
                    }
                )
                .onAppear {
                    viewStore.send(.onAppear)
                }
        }
    }

    @ViewBuilder
    func content(_ viewStore: ViewStoreOf<ViaryList>) -> some View {
        let viaries = viewStore.viaries
        if viaries.isEmpty {
            Button {
                viewStore.send(.createSample)
            } label: {
                SelectableText("Create")
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

    var list: some View {
        WithViewStore(store, observe: \.viaries) { viewStore in
            List {
                ForEach(viewStore.state) { viary in
                    VStack(alignment: .leading) {
                        SelectableText(viary.message)
                        LazyVStack {
                            ForEach(Emotion.Kind.allCases) { kind in
                                let value = viary.score(of: kind)
                                HStack {
                                    SelectableText(kind.text)
                                    ProgressView(value: Double(value) / 100)
                                        .foregroundColor(kind.color)
                                    SelectableText("\(value)%")
                                }
                            }
                        }
                        HStack {
                            Text(viary.date, style: .relative)
                                .foregroundColor(.secondary)
                            Spacer()
                        }
                    }
                    .onTapGesture {
                        viewStore.send(.transit(.viaryDetail(viary)))
                    }
                }
            }
        }
    }
}
