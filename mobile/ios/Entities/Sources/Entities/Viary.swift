import Foundation
import IdentifiedCollections
import Tagged

public struct Viary: Identifiable, Equatable {
    public let id: Tagged<Self, String>
    public var messages: [Message]
    // TODO: Remove lang property
    public var lang: Lang
    public var date: Date
    public var emotions: IdentifiedArrayOf<Emotion>

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
        public var message: String
        public var lang: Lang
        public var updatedAt: Date

        public var id: String {
            "\(updatedAt)-\(message)"
        }

        public init(message: String, lang: Lang, updatedAt: Date = Date()) {
            self.message = message
            self.lang = lang
            self.updatedAt = updatedAt
        }
    }

    public init(
        id: Tagged<Self, String>,
        messages: [Message],
        lang: Lang,
        date: Date,
        emotions: IdentifiedArrayOf<Emotion>
    ) {
        self.id = id
        self.messages = messages
        self.lang = lang
        self.date = date
        self.emotions = emotions
    }
}

public extension Viary {
    static func sample() -> Viary {
        Viary(
            id: Tagged<Viary, String>.uuid,
            messages: [
                .init(message: "This is sample viary!", lang: .en)
            ],
            lang: .en,
            date: .now,
            emotions: []
        )
    }
}

private extension Tagged where RawValue == String {
    static var uuid: Self {
        Self(UUID().uuidString)
    }
}
