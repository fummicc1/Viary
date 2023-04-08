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
                        Section("Date") {
                            date
                        }
                        Section("Status") {
                            currentStatus
                        }
                        Section("Note") {
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

    var currentStatus: some View {
        WithViewStore(store) { viewStore in
            VStack(alignment: .leading) {                
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
                        CopyableText(message.message)
                        HStack {
                            Spacer()
                            Text(message.updatedAt, style: .time)
                        }
                    }
                    .swipeActions {
                        Button("Delete") {
                            let _ = withAnimation {
                                viewStore.send(.delete(message))
                            }
                        }
                        .tint(.red)
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
