//
//  iosApp.swift
//  ios
//
//  Created by Fumiya Tanaka on 2023/01/09.
//

import SwiftUI
import ComposableArchitecture
import App

@main
struct iosApp: App {
    var body: some Scene {
        WindowGroup {
            AppScreen(
                store: StoreOf<AppReducer>(
                    initialState: AppReducer.State(),
                    reducer: AppReducer()
                )
            )
        }
    }
}
