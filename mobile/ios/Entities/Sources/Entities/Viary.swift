import Foundation
import IdentifiedCollections
import Tagged

public struct Viary {
    public let id: Tagged<Self, Int>
    public var message: String
    public var date: Date
    public var emotions: IdentifiedArrayOf<Emotion>

    public init(
        id: Tagged<Self, Int>,
        message: String,
        date: Date,
        emotions: IdentifiedArrayOf<Emotion>
    ) {
        self.id = id
        self.message = message
        self.date = date
        self.emotions = emotions
    }
}
