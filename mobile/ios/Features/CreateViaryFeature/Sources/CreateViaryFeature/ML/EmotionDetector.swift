//
//  EmotionDetector.swift
//  
//
//  Created by Fumiya Tanaka on 2023/03/19.
//

import Foundation
import CoreML
import Entities
import Resources

public protocol EmotionDetector {
    func infer(text: String, lang: Lang) -> [Double]
}

public class EmotionDetectorImpl {

    private let model: emotion_classification_model
    private let tokenizer: BertTokenizer

    public init() {
        model = try! emotion_classification_model()
        tokenizer = BertTokenizer()
    }
}

extension EmotionDetectorImpl: EmotionDetector {
    public func infer(text: String, lang: Lang) -> [Double] {
        assert(lang == .en)
        return predictEmotion(text: "This is a sample input text.")
    }

    func createAttentionMask(text: String) throws -> MLMultiArray {
        let model = BertTokenizer()
        let tokens = model.tokenizeToIds(text: text)

        let attentionMask = try MLMultiArray(shape: [1, tokens.count as NSNumber], dataType: .int32)

        for (index, token) in tokens.enumerated() {
            if token == 1 {
                attentionMask[index] = 0
            } else {
                attentionMask[index] = 1
            }
        }
        return attentionMask
    }

    func predictEmotion(text: String) -> [Double] {
        // Load the Core ML model
        guard let model = try? emotion_classification_model() else {
            print("Error loading Core ML model")
            return []
        }

        // Tokenize the input text and create the attention_mask
        let tokenizer = BertTokenizer()
        let inputTokens = tokenizer.tokenizeToIds(text: text)
        let inputArray = try! MLMultiArray(shape: [1, inputTokens.count as NSNumber], dataType: .int32)

        for (index, token) in inputTokens.enumerated() {
            inputArray[index] = token as NSNumber
        }
        let attentionMask = try? createAttentionMask(text: text)

        // Create the model input
        let input = emotion_classification_modelInput(input_ids: inputArray, attention_mask: attentionMask!)

        // Perform the prediction
        guard let prediction = try? model.prediction(input: input) else {
            print("Error making prediction")
            return []
        }

        // Handle the prediction result
        let emotionProbabilities = prediction.featureValue(for: "classLabelProbs")
        let predictedEmotion = prediction.classLabel

        let emotions = emotionProbabilities?.dictionaryValue
            .values.compactMap { $0.doubleValue } ?? []

        print("Predicted emotion: \(predictedEmotion)")
        print("Emotion probabilities: \(emotionProbabilities)")
        return emotions
    }
}
