import SwiftUI
import ComposableArchitecture
import Entities
import SharedUI

public struct CreateViaryScreen: View {

    let store: StoreOf<CreateViary>
    @FocusState var focus
    @Environment(\.dismiss) var dismiss

    public var body: some View {
        WithViewStore(store) { viewStore in
            NavigationView {
                ScrollView {
                    VStack {
                        date
                    }
                    .padding()
                    note
                        .padding(6)
                }
                .toolbar {
                    ToolbarItem {
                        CloseButton {
                            dismiss()
                        }
                    }
                }
                .navigationTitle("Create new Viary")
            }
        }
    }

    var note: some View {
        WithViewStore(store) { viewStore in            
            VStack(alignment: .leading) {
                LangListSelectionView(
                    selectedLang: viewStore.binding(
                        get: \.currentLang,
                        send: { .editLang($0) }
                    )
                )
                InputTypeSelectionView(
                    selectedInputType: viewStore.binding(
                        get: \.currentInput.type,
                        send: { .editInputType($0) }
                    )
                )
                Button {
                    focus.toggle()
                } label: {
                    Text("Note")
                        .font(.title3)
                        .foregroundColor(.textColor)
                }
                ZStack(alignment: .leading) {
                    TextEditor(
                        text: viewStore.binding(
                            get: \.currentInput.message,
                            send: { .editMessage($0) }
                        )
                    )
                    .focused($focus)
                    .scrollContentBackground(.hidden)
                    .background(Color.accentColor.opacity(0.3))
                    .cornerRadius(4)
                    .frame(minHeight: 64)
                    if viewStore.message.isEmpty && !focus {
                        VStack(alignment: .leading) {
                            Text("Let's note!")
                                .foregroundColor(.secondary)
                                .padding(2)
                            Spacer()
                        }
                        .onTapGesture {
                            focus = true
                        }
                    }
                }
            }
            .toolbar {
                ToolbarItem(placement: .keyboard) {
                    CloseButton(.text) {
                        focus = false
                    }
                }
            }
        }
    }

    var date: some View {
        WithViewStore(store) { viewStore in
            DateSelectionView(
                selectedDate: viewStore.binding(get: \.date, send: { .editDate($0) })
            )
        }
    }
}
