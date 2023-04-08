import Foundation
import SwiftUI

public struct Emotion: Identifiable, Equatable {
    public var sentence: String
    public var score: Int
    public var kind: Kind

    public var id: String {
        kind.id
    }

    public init(sentence: String, score: Int, kind: Kind) {
        self.sentence = sentence
        self.score = score
        self.kind = kind
    }

    public static func make(message: String, with scores: [Double]) -> [Self] {
        var emotions: [Self] = []
        for (i, score) in scores.enumerated() {
            let kind = Emotion.Kind.allCases[i]
            assert(score <= 1)
            emotions.append(
                Emotion(
                    sentence: message,
                    score: Int(Double(score) * 100),
                    kind: kind
                )
            )
        }
        return emotions
    }
}

public extension Emotion {
    enum Kind: String, Equatable, Identifiable, CaseIterable {
        case anger
        case disgust
        case fear
        case joy
        case neutral
        case sadness
        case surprise
        case unknown

        public var id: String {
            rawValue
        }

        public var text: String {
            rawValue
        }

        public var color: Color {
            Color.orange
        }
    }
}
