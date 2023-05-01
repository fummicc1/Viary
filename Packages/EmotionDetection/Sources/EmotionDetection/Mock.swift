///
/// @Generated by Mockolo
///



import CoreML
import Entities
import Foundation
import Resources


public class EmotionDetectorMock: EmotionDetector {
    public init() { }


    public private(set) var inferCallCount = 0
    public var inferHandler: ((String, Lang) async -> ([Double]))?
    public func infer(text: String, lang: Lang) async -> [Double] {
        inferCallCount += 1
        if let inferHandler = inferHandler {
            return await inferHandler(text, lang)
        }
        return [Double]()
    }
}
