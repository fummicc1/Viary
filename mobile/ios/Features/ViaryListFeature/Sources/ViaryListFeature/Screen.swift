import Foundation
import Entities
import ComposableArchitecture
import SwiftUI

public struct ViaryListScreen: View {
    let store: StoreOf<ViaryList>

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
                    list
                }
            }
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
