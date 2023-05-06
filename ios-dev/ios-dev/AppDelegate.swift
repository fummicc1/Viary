//
//  AppDelegate.swift
//  ios-dev
//
//  Created by Fumiya Tanaka on 2023/05/06.
//

import Foundation
import UIKit
import ComposableArchitecture
import App

public final class AppDelegate: NSObject, UIApplicationDelegate {
    let store = StoreOf<AppReducer>(
        initialState: AppReducer.State(),
        reducer: AppReducer()
    )

    var viewStore: ViewStore<Void, AppReducer.Action> {
        ViewStore(store.stateless)
    }

    public func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        viewStore.send(.appDelegate(.didFinishLaunching))
        return true
    }
}
