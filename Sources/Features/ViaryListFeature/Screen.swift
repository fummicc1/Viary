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
            let viaries = viewStore.filteredViaries
            if viaries.isEmpty {
                FloatingActionable(
                    .bottomTrailing,
                    fab: .image(.init(systemSymbol: .plus))
                ) {
                    ProgressView()
                        .progressViewStyle(.circular)
                } didPress: {
                    viewStore.send(.createSample)
                }

            } else {
                FloatingActionable(
                    .bottomTrailing,
					fab: .image(Image(systemSymbol: .plus))
                ) {
					VStack {
						ScrollView(.horizontal) {
							calendar(viewStore: viewStore)
						}
						.frame(height: 300)
						.padding(10)
						.clipShape(RoundedRectangle(cornerRadius: 10))
						.padding(10)
						list(viewStore: viewStore)
					}
					.background(Color.clear)
                } didPress: {
                    viewStore.send(.didTapCreateButton)
                }
            }
        }
    }

	@MainActor
	@ViewBuilder
	func calendar(viewStore: ViewStoreOf<ViaryList>) -> some View {
		// 90 days
		let duration: TimeInterval = 60 * 60 * 24 * 90
		let end = Date()
		let start = end.addingTimeInterval(-duration)
		EquatableCalendarView(interval: .init(start: start, end: end), value: viewStore.selecteddate) { date in
			Button(action: {
				if date == viewStore.selecteddate {
					viewStore.send(.select(nil))
				} else {
					viewStore.send(.select(date))
				}
			}, label: {
				if date == viewStore.selecteddate {
					Text(date.day).lineLimit(1).frame(width: 24, height: 24)
						.foregroundStyle(Color.backgroundColor)
						.padding(2)
						.background(Color.accentColor)
						.clipShape(Circle())
				} else {
					Text(date.day).lineLimit(1).frame(width: 24, height: 24)
						.foregroundStyle(Color.accentColor)
						.padding(2)
				}
			})
		}
	}

    @MainActor
    func list(viewStore: ViewStoreOf<ViaryList>) -> some View {
        List {
            ForEach(viewStore.filteredViaries.keys.map { $0 }) { (key: String) in
                Section {
                    ForEach(viewStore.filteredViaries[key] ?? [], id: \.self) { (viary: Viary) in
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

extension Date {
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
        return "\(component)"
    }

    var year: String {
        let calender = Calendar.autoupdatingCurrent
        let component = calender.component(.year, from: self)
        return "\(component)"
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
