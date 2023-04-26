import Foundation
import Dependencies

public enum SpeechToTextServiceKey: DependencyKey {
    public static var liveValue: SpeechToTextService = SpeechToTextServiceImpl(locale: Locale.autoupdatingCurrent)
}

public extension DependencyValues {
    var speechToTextService: SpeechToTextService {
        get {
            self[SpeechToTextServiceKey.self]
        }
        set {
            self[SpeechToTextServiceKey.self] = newValue
        }
    }
}
