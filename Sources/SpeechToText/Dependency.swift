import Foundation
import Dependencies

public enum SpeechToTextServiceKey: DependencyKey {
    public static var liveValue: any SpeechToTextService = SpeechToTextServiceImpl(locale: Locale(identifier: "en-US"))
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
