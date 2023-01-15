import Foundation
import ComposableArchitecture
import SwiftUI

public struct ViaryListScreen: View {

    let store: Store<ViaryListState, ViaryListAction>

    public init(store: Store<ViaryListState, ViaryListAction>) {
        self.store = store
    }

    public var body: some View {
        WithViewStore(store) { viewStore in
            List {
                ForEach(viewStore.viaries) { viary in
                    VStack {
                        Text(viary.message)
                        HStack {
                            Text(viary.date, style: .relative)
                        }
                    }
                }
            }
        }
    }
}
