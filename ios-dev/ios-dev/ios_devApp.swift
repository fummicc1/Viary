//
//  ios_devApp.swift
//  ios-dev
//
//  Created by Fumiya Tanaka on 2023/04/27.
//

import SwiftUI
import ComposableArchitecture
import EmotionDetection
import App

@main
struct ios_devApp: App {
    var body: some Scene {
        WindowGroup {
            withDependencies {
                $0.emotionDetector = EmotionDetectorMock()
            } operation: {
                AppScreen()
            }
        }
    }
}
