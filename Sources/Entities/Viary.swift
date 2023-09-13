import Foundation
import IdentifiedCollections
import Tagged

public struct Viary: Identifiable, Equatable, Sendable {
    public private(set) var id: Tagged<Self, String>
    public var messages: IdentifiedArrayOf<Message>
    public var date: Date

    var lang: Lang {
        messages.first?.lang ?? .en
    }

    public var emotions: IdentifiedArrayOf<Emotion> {
        var emotions: [Emotion.Kind: Emotion] = [:]
        for message in messages {
            message.emotions.values.forEach { emotion in
                if var cur = emotions[emotion.kind] {
                    cur.score += Int(Double(emotion.score) / Double(messages.count))
                    emotions[emotion.kind] = cur
                } else {
                    emotions[emotion.kind] = emotion
                    emotions[emotion.kind]?.score = Int(Double(emotion.score) / Double(messages.count))
                }
            }
        }
        return IdentifiedArray(uniqueElements: emotions.values)
    }

    public var updatedAt: Date {
        messages.map(\.updatedAt).sorted().last ?? Date()
    }

    public var message: String {
        messages.map(\.sentence).joined(separator: "\n")
    }

    public func score(of emotionKind: Emotion.Kind) -> Int {
        guard let score = emotions.first(where: { $0.kind == emotionKind })?.score else {
            return 0
        }
        return score
    }

    public func asDummy() -> Self {
        .init(
            id: .init(""),
            messages: messages,
            date: date
        )
    }

    public struct Message: Identifiable, Equatable, Sendable {
        public var viaryID: Tagged<Viary, String>
        public var id: Tagged<Message, String>
        public var sentence: String
        public var lang: Lang
        public var updatedAt: Date
        public var emotions: [Emotion.Kind: Emotion]

        public init(viaryID: Tagged<Viary, String>, id: Tagged<Message, String>, sentence: String, lang: Lang, emotions: [Emotion.Kind: Emotion]? = nil, updatedAt: Date = Date()) {
            self.viaryID = viaryID
            self.id = id
            self.sentence = sentence
            self.lang = lang
            self.emotions = emotions ?? Dictionary<Emotion.Kind, Emotion>(
                uniqueKeysWithValues: Emotion.Kind.allCases
                    .map {
                        ($0, Emotion(sentence: sentence, score: 100 / Emotion.Kind.allCases.count, kind: $0))
                    }
            )
            self.updatedAt = updatedAt
        }
    }

    public init(
        id: Tagged<Self, String>,
        messages: IdentifiedArrayOf<Message>,
        date: Date
    ) {
        self.id = id
        self.messages = messages
        self.date = date

        for i in messages.indices {
            self.messages[i].viaryID = id
        }
    }
}
