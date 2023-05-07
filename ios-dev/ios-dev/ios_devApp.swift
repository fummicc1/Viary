//
//  ios_devApp.swift
//  ios-dev
//
//  Created by Fumiya Tanaka on 2023/04/27.
//

import SwiftUI
import App

@main
struct ios_devApp: App {

    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    var body: some Scene {
        WindowGroup {
            AppScreen(store: appDelegate.store) 
        }
    }
}
