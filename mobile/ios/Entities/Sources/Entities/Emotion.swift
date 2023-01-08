import Foundation

public struct Emotion: Identifiable {
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
    enum Kind: String, Identifiable {
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
    }
}