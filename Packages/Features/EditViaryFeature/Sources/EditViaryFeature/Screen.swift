import Foundation
import ComposableArchitecture
import SharedUI
import SwiftUI
import Entities
import SFSafeSymbols

public struct EditViaryScreen: View {

    let store: StoreOf<EditViary>

    @FocusState private var focused
    @Environment(\.dismiss) var dismiss

    public init(store: StoreOf<EditViary>) {
        self.store = store
    }

    public var body: some View {
        WithViewStore(
            store,
            observe: { $0 }
        ) { viewStore in
            ZStack {
                ScrollViewReader { reader in
                    ScrollView {
                        LazyVStack {
                            ForEach(viewStore.messages) { message in
                                item(viewStore: viewStore, message: message)
                                    .id(message.id)
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
                    .onChange(of: viewStore.focusedMessage) { message in
                        if let message {
                            withAnimation {
                                reader.scrollTo(message.id, anchor: .top)
                            }
                        }
                    }
                    .onChange(of: focused) {
                        if !$0 {
                            viewStore.send(.closeKeyboard)
                        }
                    }
                }
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        HStack(spacing: 16) {
                            let text = viewStore.canEditable ? "View" : "Edit"
                            Button {
                                viewStore.send(.toggleMode)
                            } label: {
                                HStack(spacing: 8) {
                                    Text(text)
                                    Image(systemSymbol: viewStore.canEditable ? .pencilSlash : .pencil)
                                }
                            }
                        }
                        .padding()
                        .background(Color.secondaryBackgroundColor)
                        .cornerRadius(12)
                    }
                    .padding()
                }
            }
            .navigationTitle(viewStore.editable.date.formatted())
            .navigationBarTitleDisplayMode(.inline)
        }
    }

    private func item(viewStore: ViewStoreOf<EditViary>, message: Viary.Message) -> some View {
        HStack {
            VStack(spacing: .zero) {
                TextEditor(
                    text: viewStore.binding(
                        get: { $0.editable.messages.first(where: { $0.id == message.id })?.sentence ?? "" },
                        send: { .editMessageSentence(id: message.id, sentence: $0) }
                    )
                ).font(.body)
                .focused($focused)
                .trackFrame()
                .frame(height: viewStore.scrollContentHeight[message.id])
                .onTapGesture {
                    viewStore.send(.tapMessage(id: message.id))
                }
                Spacer().frame(height: 4)
                Divider()
                Spacer().frame(height: 4)
                LazyVStack {
                    ForEach(Emotion.Kind.allCases, id: \.id) { kind in
                        HStack {
                            SelectableText(kind.text)
                            let score = viewStore
                                .editable
                                .messages[id: message.id]?
                                .emotions[kind]?
                                .prob(
                                    all: message.emotions.values.map { $0 }
                                ) ?? 0
                            Group {
                                if viewStore.canEditable {
                                    Slider(value: viewStore.binding(
                                        get: { _ in score },
                                        send: { (prob: Double) in
                                            .editMessageEmotion(
                                                id: message.id,
                                                emotionKind: kind,
                                                prob: prob
                                            )
                                        }
                                    ))
                                } else {
                                    ProgressView(value: score)
                                }
                            }.padding(2)
                            let value = message.emotions[kind]?.score ?? 0
                            SelectableText("\(value)%")
                        }
                    }
                }
            }
            if viewStore.canEditable {
                let resolvedAnalysis = viewStore.resolved[message.id] ?? false
                Button("Analyze") {
                    viewStore.send(.analyze(messageID: message.id))
                }
                .buttonStyle(.borderedProminent)
                .disabled(resolvedAnalysis)
            }
        }
        .onFrameDidChange { data in
            guard let frame = data.last?.bounds else {
                return
            }
            viewStore.send(.didAdjustMessageHeight(
                id: message.id,
                height: message.calculateContentHeight(width: frame.width)
            ))
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
            options: [.usesLineFragmentOrigin, .usesFontLeading],
            attributes: [
                .font: UIFont.preferredFont(forTextStyle: .body)
            ],
            context: nil
        )
        // FIXME: This should be removed.
        let buffer: Double = 24
        return size.height + buffer
    }
}
