//
//  EmotionDetector+DI.swift
//  
//
//  Created by Fumiya Tanaka on 2023/03/22.
//

import Foundation
import Dependencies


public struct EmotionDetectorEnvKey: DependencyKey {
    public static var liveValue: EmotionDetector = EmotionDetectorImpl()
}

public extension DependencyValues {
    var emotionDetector: EmotionDetector {
        get {
            self[EmotionDetectorEnvKey.self]
        } set {
            self[EmotionDetectorEnvKey.self] = newValue
        }
    }
}
