import Foundation
import SwiftUI

public struct Emotion: Identifiable, Equatable {
    public var sentence: String
    public var score: Int
    public var kind: Kind

    public var id: Kind {
        kind
    }

    public init(sentence: String, score: Int, kind: Kind) {
        self.sentence = sentence
        self.score = score
        self.kind = kind
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
