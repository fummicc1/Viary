import Combine
import Foundation
import Speech

/// @mockable
public protocol SpeechToTextService {

    var onTextUpdate: AnyPublisher<SpeechToTextModel, Never> { get }
    var permission: AnyPublisher<SpeechPermission, Never> { get }
    var error: AnyPublisher<SpeechToTextError, Never> { get }

    func start() throws
}

public enum SpeechToTextError: LocalizedError {
    case invalidLocale(Locale)
}

public struct SpeechPermission: OptionSet {

    public typealias RawValue = UInt

    public var rawValue: UInt

    static public let mic: SpeechPermission = .init(rawValue: 1 << 0)
    static public let recognition: SpeechPermission = .init(rawValue: 1 << 1)

    public init(rawValue: UInt) {
        self.rawValue = rawValue
    }
}

public struct SpeechToTextModel {
    public var text: String
    public var isFinal: Bool

    public init(text: String, isFinal: Bool) {
        self.isFinal = isFinal
        self.text = text
    }
}

public class SpeechToTextServiceImpl {
    let onTextUpdateSubject: PassthroughSubject<SpeechToTextModel, Never> = .init()
    let permissionSubject: CurrentValueSubject<SpeechPermission, Never> = .init([])
    let errorSubject: PassthroughSubject<SpeechToTextError, Never> = .init()

    private let speechRecognizer: SFSpeechRecognizer
    private var request: SFSpeechAudioBufferRecognitionRequest?
    private var task: SFSpeechRecognitionTask?
    private let engine: AVAudioEngine = .init()

    public init(locale: Locale) throws {
        guard let speechRecognizer = SFSpeechRecognizer(locale: locale) else {
            throw SpeechToTextError.invalidLocale(locale)
        }
        self.speechRecognizer = speechRecognizer
    }

    func requestPermission() {
        SFSpeechRecognizer.requestAuthorization { status in

        }
    }
}

extension SpeechToTextServiceImpl: SpeechToTextService {

    public var onTextUpdate: AnyPublisher<SpeechToTextModel, Never> {
        onTextUpdateSubject.eraseToAnyPublisher()
    }

    public var permission: AnyPublisher<SpeechPermission, Never> {
        permissionSubject.eraseToAnyPublisher()
    }

    public var error: AnyPublisher<SpeechToTextError, Never> {
        errorSubject.eraseToAnyPublisher()
    }

    public func start() throws {
        let permission = permissionSubject.value
        if permission != [.mic, .recognition] {

        }
    }
}
