import Foundation
import ComposableArchitecture
import SharedUI
import SwiftUI
import Entities

public struct EditViaryScreen: View {

    let store: StoreOf<EditViary>

    @FocusState private var focused
    @Environment(\.dismiss) var dismiss

    public var body: some View {
        WithViewStore(
            store,
            observe: { $0 }
        ) { viewStore in
            ScrollView {
                VStack {
                    ForEach(viewStore.messages) { message in
                        HStack {
                            VStack {
                                Divider()
                                TextEditor(
                                    text: viewStore.binding(
                                        get: { $0.editable.messages.first(where: { $0.id == message.id })?.sentence ?? "" },
                                        send: { .editMessage(id: message.id, sentence: $0) }
                                    )
                                )
                                .focused($focused)
                                .frame(height: 150)
                                Divider()
                                LazyVStack {
                                    ForEach(Emotion.Kind.allCases) { kind in
                                        let value = message.emotions.first(where: { $0.kind == kind })?.score ?? 0
                                        HStack {
                                            SelectableText(kind.text)
                                            ProgressView(value: Double(value) / 100)
                                                .foregroundColor(kind.color)
                                            SelectableText("\(value)%")
                                        }
                                    }
                                }
                                Divider()
                            }
                            let resolvedAnalysis = viewStore.resolved[message.id] ?? false
                            Button("Analyze") {
                                viewStore.send(.analyze(messageID: message.id))
                            }
                            .buttonStyle(.borderedProminent)
                            .disabled(resolvedAnalysis)
                        }
                    }
                }
                .padding()
                .toolbar {
                    ToolbarItem(placement: .keyboard) {
                        Button("Close") {
                            focused = false
                        }
                    }
                }
                .toolbar {
                    ToolbarItem {
                        Button("Save") {
                            viewStore.send(.save)
                        }
                    }
                }
                .onChange(of: viewStore.saveStatus.response) {
                    if $0 != nil {
                        dismiss()
                    }
                }
            }
        }
    }
}
