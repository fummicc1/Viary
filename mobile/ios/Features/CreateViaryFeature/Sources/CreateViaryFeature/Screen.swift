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
                ZStack {
                    Form {
                        Section("日付") {
                            date
                        }
                        Section("メタデータ") {
                            metadata
                        }
                        Section("ノート") {
                            note
                        }
                    }
                    if viewStore.saveStatus.isLoading {
                        VStack {
                            Spacer()
                            ProgressView().progressViewStyle(.circular)
                                .bold()
                                .background(content: {
                                    RoundedRectangle(cornerRadius: 8)
                                        .foregroundColor(Color(uiColor: .systemBackground))
                                        .frame(width: 64, height: 64)
                                })
                                .frame(width: 64, height: 64)
                            Spacer()
                        }
                    }
                }
                .navigationTitle("Create new Viary")
                .toolbar {
                    if viewStore.isValidInput {
                        ToolbarItem(placement: .navigationBarTrailing) {
                            Button {
                                viewStore.send(.save)
                            } label: {
                                Image(systemSymbol: .checkmark)
                            }
                        }
                    }
                    ToolbarItem(placement: .navigationBarLeading) {
                        CloseButton {
                            dismiss()
                        }
                    }
                }
            }
            .onChange(of: viewStore.saveStatus.response, perform: { newValue in
                if newValue == true {
                    dismiss()
                }
            })
            .onAppear {
                viewStore.send(.onAppear)
            }
        }
    }

    var metadata: some View {
        WithViewStore(store) { viewStore in
            VStack(alignment: .leading) {
                LangListSelectionView(
                    selectedLang: viewStore.binding(
                        get: \.currentLang,
                        send: { .editLang($0) }
                    )
                )
                SpeechStatusView(
                    status: viewStore.speechStatus,
                    viewStore: viewStore
                )
            }
        }
    }

    var note: some View {
        WithViewStore(store) { viewStore in            
            List {
                ForEach(viewStore.messages) { message in
                    VStack {
                        Text(message.message)
                        HStack {
                            Spacer()
                            Text(message.updatedAt, style: .time)
                        }
                    }
                }
                .onDelete { index in
                    // TODO: Delete feature
                }
                .swipeActions {
                    Button("編集") {
                        // TODO: Edit feature
                    }
                    .tint(.orange)
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
