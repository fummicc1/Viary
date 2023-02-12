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
                        lang
                    }
                    .padding()
                    note
                        .padding(6)
                }
                .toolbar {
                    ToolbarItem {
                        Button {
                            dismiss()
                        } label: {
                            Image(systemSymbol: .xmarkCircle)
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
                Button {
                    focus.toggle()
                } label: {
                    Text("Note")
                        .foregroundColor(.textColor)
                }
                ZStack(alignment: .leading) {
                    TextEditor(text: viewStore.binding(get: \.message, send: { .editMessage($0) }))
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
        }
    }

    var lang: some View {
        WithViewStore(store) { viewStore in
            Picker(
                selection: viewStore.binding(get: \.lang, send: { .editLang($0) })
            ) {
                ForEach(Lang.allCases) { lang in
                    Text(lang.displayName)
                        .bold()
                        .tag(lang)
                }
            } label: {
                Text("Language")
            }
            .pickerStyle(.segmented)
        }
    }

    var date: some View {
        WithViewStore(store) { viewStore in
            DatePicker("Date", selection: viewStore.binding(get: \.date, send: { .editDate($0) }), displayedComponents: .date)
                .datePickerStyle(.graphical)
        }
    }
}
