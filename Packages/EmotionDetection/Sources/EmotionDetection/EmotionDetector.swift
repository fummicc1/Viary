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

/// @mockable
public protocol EmotionDetector {
    func infer(text: String, lang: Lang) async -> [Double]
}

public class EmotionDetectorImpl {

    private let model: emotion_english_distilroberta_base
    private let tokenizer: BertTokenizer

    public init() {
        model = try! emotion_english_distilroberta_base()
        tokenizer = BertTokenizer()
    }

    private func multiArrayToArray(_ multiArray: MLMultiArray) -> [Double] {
        let length = multiArray.count
        var ret: [Double] = []
        for i in 0..<length {
            ret.append(multiArray[i].doubleValue)
        }
        return ret
    }
}

extension EmotionDetectorImpl: EmotionDetector {
    public func infer(text: String, lang: Lang) async -> [Double] {
        assert(lang == .en)
        return await Task {
            await predictEmotion(text: text)
        }.value
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

    func predictEmotion(text: String) async -> [Double] {
        // Load the Core ML model
        let inputTokens = tokenizer.tokenizeToIds(text: text)
        let inputArray = try! MLMultiArray(shape: [1, inputTokens.count as NSNumber], dataType: .int32)

        for (index, token) in inputTokens.enumerated() {
            inputArray[index] = token as NSNumber
        }
        let attentionMask = try? createAttentionMask(text: text)

        // Create the model input
        let input = emotion_english_distilroberta_baseInput(input_ids: inputArray, attention_mask: attentionMask!)

        // Perform the prediction
        guard let prediction = try? model.prediction(input: input) else {
            return []
        }

        // Handle the prediction result
        let predictedEmotion = prediction.inp

        let ret: [Double] = multiArrayToArray(predictedEmotion)

        #if DEBUG
        print("Predicted emotion: \(predictedEmotion)")
        #endif
        return ret
    }
}
