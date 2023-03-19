//
//  EmotionDetector.swift
//  
//
//  Created by Fumiya Tanaka on 2023/03/19.
//

import Foundation
import CoreML
import Resources

public protocol EmotionDetector {
    func infer(text: String) -> [Double]
}

public class EmotionDetectorImpl {

    private let model: emotion_classification

    public init() {
        model = emotion_classification()
    }
}

extension EmotionDetectorImpl: EmotionDetector {
    public func infer(text: String) -> [Double] {
        let data = text.components(separatedBy: .whitespacesAndNewlines)
        let input = emotion_classificationInput(input_ids_1: MLMultiArray(data))
        model.prediction(input: input)
    }
}
