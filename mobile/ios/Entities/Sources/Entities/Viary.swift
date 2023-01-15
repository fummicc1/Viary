import Foundation
import IdentifiedCollections
import Tagged

public struct Viary: Identifiable, Equatable {
    public let id: Tagged<Self, String>
    public var message: String
    public var lang: Lang
    public var date: Date
    public var emotions: IdentifiedArrayOf<Emotion>

    public init(
        id: Tagged<Self, String>,
        message: String,
        lang: Lang,
        date: Date,
        emotions: IdentifiedArrayOf<Emotion>
    ) {
        self.id = id
        self.message = message
        self.lang = lang
        self.date = date
        self.emotions = emotions
    }
}
