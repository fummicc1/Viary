import Foundation
import ComposableArchitecture
import SwiftUI

public struct EditViaryScreen: View {

    let store: StoreOf<EditViary>

    public var body: some View {
        WithViewStore(
            store,
            observe: { $0 }
        ) { viewStore in
            VStack {
                Text(viewStore.totalSentece)
            }
        }
    }
}
