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
            ForEach(viewStore.viaries.keys.map { $0 }) { (key: String) in
                Section {
                    ForEach(viewStore.viaries[key] ?? [], id: \.self) { (viary: Viary) in
                        listItem(viary: viary)
                    }
                } header: {
                    Text(key).bold().font(.title3)
                }
            }
        }
    }

    @MainActor
    func listItem(viary: Viary) -> some View {
        HStack {
            VStack(spacing: 4) {
                Text(viary.date.weekDay)
                    .bold()
                    .foregroundStyle(Color.accentColor)
                Text(viary.date.day)
                    .bold()
                    .font(.title3)
                    .foregroundStyle(Color.accentColor)
                Text(viary.date.formatted(date: .omitted, time: .shortened))
                    .foregroundStyle(Color.accentColor)
            }
            .padding(4)
            .background(Color.secondaryBackgroundColor)
            .clipShape(RoundedRectangle(cornerRadius: 10))
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
            }
        }
        .onTapGesture {
            viewStore.send(.didTap(viary: viary))
        }
    }
}

private extension Date {
    var weekDay: String {
        let calender = Calendar.autoupdatingCurrent
        let component = calender.component(.weekday, from: self)
        switch component {
        case 1:
            return "SUN"
        case 2:
            return "MON"
        case 3:
            return "TUE"
        case 4:
            return "WED"
        case 5:
            return "THU"
        case 6:
            return "FRI"
        case 7:
            return "SAT"
        default:
            return ""
        }

    }

    var month: String {
        let calender = Calendar.autoupdatingCurrent
        let component = calender.component(.month, from: self)
        return "\(component)月"
    }


    var day: String {
        let calender = Calendar.autoupdatingCurrent
        let component = calender.component(.day, from: self)
        return "\(component)"
    }
}

extension String: Identifiable {
    public var id: String {
        self
    }
}
