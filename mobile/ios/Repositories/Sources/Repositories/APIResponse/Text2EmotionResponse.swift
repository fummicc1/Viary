import Foundation

public struct Text2EmotionResponse: Decodable {
    public let result: [[Result]]
}

public extension Text2EmotionResponse {
    struct Result: Decodable {
        public let label: String
        public let score: Double
    }
}
