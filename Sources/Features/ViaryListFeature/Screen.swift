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
            .navigationBarTitleDisplayMode(.inline)
            .onAppear {
                viewStore.send(.onAppear)
            }
    }

    @MainActor
    func content(_ viewStore: ViewStoreOf<ViaryList>) -> some View {
        VStack {
            let viaries = viewStore.viaries
            if viaries.isEmpty {
                ProgressView()
                    .progressViewStyle(.circular)
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

    @MainActor
    func list(viewStore: ViewStoreOf<ViaryList>) -> some View {
        List {
            ForEach(viewStore.viaries) { viary in
                HStack {
                    VStack {
                        Text(viary.date.weekDay)
                            .bold()
                        Text(viary.date.month)
                            .bold()
                    }
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
                }
                .onTapGesture {
                    viewStore.send(.didTap(viary: viary))
                }
            }
        }
    }
}

private extension Date {
    var weekDay: String {
        let calender = Calendar.autoupdatingCurrent
        let component = calender.component(.day, from: self)
        switch component {
        case 0:
            return "SUN"
        case 1:
            return "MON"
        case 2:
            return "TUE"
        case 3:
            return "WED"
        case 4:
            return "THU"
        case 5:
            return "FRI"
        case 6:
            return "SAT"
        default:
            return ""
        }

    }

    var month: String {
        let calender = Calendar.autoupdatingCurrent
        let component = calender.component(.month, from: self)
        return "\(component + 1)月"
    }
}
