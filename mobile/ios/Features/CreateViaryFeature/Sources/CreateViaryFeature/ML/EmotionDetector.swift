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
        let tokens = tokenizer.tokenize(text: text).map { tokenizer.tokenToId(token: $0) }.map { Float($0) }
        let inputIds = MLShapedArray(scalars: tokens, shape: [tokens.count, 1])
        let input = emotion_classification_modelInput(input_ids_1: inputIds)
        let results = try! model.prediction(input: input)
        dump(results)
        let doubles = try! UnsafeBufferPointer<Double>(results.hidden_states)
        return Array(doubles)
    }
}
