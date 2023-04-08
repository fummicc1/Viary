//
//  iosApp.swift
//  ios
//
//  Created by Fumiya Tanaka on 2023/01/09.
//

import SwiftUI
import ComposableArchitecture
import ViaryListFeature

@main
struct iosApp: App {
    var body: some Scene {
        withDependencies {
            $0.router = AppRouter()
        } operation: {
            WindowGroup {
                NavigationStack {
                    ViaryListScreen(
                        store: StoreOf<ViaryList>(
                            initialState: ViaryList.State(),
                            reducer: ViaryList()
                        )
                    )
                }
            }
        }
    }
}
