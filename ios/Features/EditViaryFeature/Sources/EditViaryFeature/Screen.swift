import Foundation
import ComposableArchitecture
import SharedUI
import SwiftUI
import Entities

public struct EditViaryScreen: View {

    let store: StoreOf<EditViary>

    @FocusState private var focused
    @Environment(\.dismiss) var dismiss
    @State private var scrollContentSize: [Viary.Message.ID: CGSize] = [:]

    public var body: some View {
        WithViewStore(
            store,
            observe: { $0 }
        ) { viewStore in
            ScrollView {
                LazyVStack {
                    ForEach(viewStore.messages) { message in
                        item(viewStore: viewStore, message: message)
                        Divider()
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

    private func item(viewStore: ViewStoreOf<EditViary>, message: Viary.Message) -> some View {
        HStack {
            VStack {
                TextEditor(
                    text: viewStore.binding(
                        get: { $0.editable.messages.first(where: { $0.id == message.id })?.sentence ?? "" },
                        send: { .editMessage(id: message.id, sentence: $0) }
                    )
                )
                .focused($focused)
                .frame(
                    height: message.calculateContentHeight(
                        width: scrollContentSize[message.id]?.width ?? .zero
                    )
                )
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
            }
            .trackFrame()
            .onFrameDidChange { data in
                guard let frame = data.last?.bounds else {
                    return
                }
                scrollContentSize[message.id] = frame.size
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

fileprivate extension Viary.Message {
    func calculateContentHeight(width: CGFloat) -> CGFloat {
        let sentence = sentence as NSString
        let size = sentence.boundingRect(
            with: .init(
                width: width,
                height: Double.greatestFiniteMagnitude
            ),
            attributes: [
                .font: UIFont.preferredFont(forTextStyle: .body)
            ],
            context: nil
        )
        let padding: Double = 32
        return size.height + padding
    }
}
