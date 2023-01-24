import Foundation
import Entities
import ComposableArchitecture
import SwiftUI

public struct ViaryListScreen: View {
    let store: StoreOf<ViaryList>

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
