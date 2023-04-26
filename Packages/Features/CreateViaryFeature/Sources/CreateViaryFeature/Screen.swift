import SwiftUI
import ComposableArchitecture
import Entities
import SharedUI

public struct CreateViaryScreen: View {

    let viewStore: ViewStoreOf<CreateViary>
    @FocusState var focus
    @Environment(\.dismiss) var dismiss

    public init(viewStore: ViewStoreOf<CreateViary>) {
        self.viewStore = viewStore
    }

    public var body: some View {
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
        .onDisappear {
            viewStore.send(.onDisappear)
        }
    }

    var currentStatus: some View {
        VStack(alignment: .leading) {
            SpeechStatusView(
                status: viewStore.speechStatus,
                viewStore: viewStore
            )
        }

    }

    var note: some View {
        List {
            ForEach(viewStore.messages) { message in
                VStack {
                    SelectableText(message.sentence)
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

    var date: some View {
        DateSelectionView(
            selectedDate: viewStore.binding(get: \.date, send: { .editDate($0) })
        )
    }
}
