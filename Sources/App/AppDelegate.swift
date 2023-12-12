//
//  AppDelegate.swift
//  ios-dev
//
//  Created by Fumiya Tanaka on 2023/05/06.
//

import Foundation
import UIKit
@_spi(Internals) import ComposableArchitecture

public final class AppDelegate: NSObject, UIApplicationDelegate {
    public let store = StoreOf<AppReducer>(
        initialState: AppReducer.State(),
        reducer: { AppReducer() }
    )

    public func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        store.send(.appDelegate(.didFinishLaunching))
        return true
    }
}
