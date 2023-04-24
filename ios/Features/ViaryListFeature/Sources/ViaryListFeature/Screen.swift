import Foundation
import Entities
import ComposableArchitecture
import FloatingActionButton
import SwiftUI
import SharedUI
import SwiftUINavigation

public struct ViaryListScreen: View {
    let viewStore: ViewStoreOf<ViaryList>

    public init(viewStore: ViewStoreOf<ViaryList>) {
        self.viewStore = viewStore
    }

    public var body: some View {
        content(viewStore)
            .navigationTitle("Timeline")
            .onAppear {
                viewStore.send(.onAppear)
            }
    }

    func content(_ viewStore: ViewStoreOf<ViaryList>) -> some View {
        VStack {
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
                    list(viewStore: viewStore)
                } didPress: {
                    viewStore.send(.didTapCreateButton)
                }
            }
        }
    }

    func list(viewStore: ViewStoreOf<ViaryList>) -> some View {
        List {
            ForEach(viewStore.viaries) { viary in
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
                    viewStore.send(.didTap(viary: viary))
                }
            }
        }
    }
}
