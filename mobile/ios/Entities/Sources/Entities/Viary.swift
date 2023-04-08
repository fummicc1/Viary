import Foundation
import IdentifiedCollections
import Tagged

public struct Viary: Identifiable, Equatable {
    public let id: Tagged<Self, String>
    public var messages: [Message]
    public var date: Date

    var lang: Lang {
        messages.first?.lang ?? .en
    }

    public var emotions: IdentifiedArrayOf<Emotion> {
        var emotions: [Emotion.Kind: Emotion] = [:]
        for message in messages {
            message.emotions.forEach { emotion in
                if var cur = emotions[emotion.kind] {
                    cur.score += Int(Double(emotion.score) / Double(messages.count))
                    emotions[emotion.kind] = cur
                } else {
                    emotions[emotion.kind] = emotion
                }
            }
        }
        return IdentifiedArray(uniqueElements: emotions.values)
    }

    public var updatedAt: Date {
        messages.map(\.updatedAt).sorted().last ?? Date()
    }

    public var message: String {
        messages.map(\.message).joined(separator: "\n")
    }

    public func score(of emotionKind: Emotion.Kind) -> Int {
        guard let score = emotions.first(where: { $0.kind == emotionKind })?.score else {
            return 0
        }
        return score
    }

    public struct Message: Identifiable, Equatable {
        public var viaryID: Tagged<Viary, String>
        public var message: String
        public var lang: Lang
        public var updatedAt: Date
        public var emotions: [Emotion]

        public var id: String {
            "\(viaryID)-\(message)"
        }

        public init(viaryID: Tagged<Viary, String>, message: String, lang: Lang, emotions: [Emotion] = [], updatedAt: Date = Date()) {
            self.viaryID = viaryID
            self.message = message
            self.lang = lang
            self.emotions = emotions
            self.updatedAt = updatedAt
        }
    }

    public init(
        id: Tagged<Self, String>,
        messages: [Message],
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

public extension Viary {
    static func sample() -> Viary {
        let uuid = Tagged<Viary, String>.uuid
        return Viary(
            id: uuid,
            messages: [
                .init(viaryID: uuid, message: "This is sample viary!", lang: .en)
            ],
            date: .now
        )
    }
}

private extension Tagged where RawValue == String {
    static var uuid: Self {
        Self(UUID().uuidString)
    }
}
