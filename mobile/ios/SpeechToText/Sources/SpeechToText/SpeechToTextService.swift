import Combine
import AVFoundation
import Foundation
import Speech

/// @mockable
public protocol SpeechToTextService {

    var onTextUpdate: AnyPublisher<SpeechToTextModel, Never> { get }
    var permission: AnyPublisher<SpeechPermission, Never> { get }
    var error: AnyPublisher<SpeechToTextError, Never> { get }
    var speechStatus: AnyPublisher<SpeechStatus, Never> { get }

    func start() async throws
}

public enum SpeechToTextError: LocalizedError {
    case invalidLocale(Locale)
    case missingPermission(SpeechPermission)
    case failedPreparation
}

public enum SpeechStatus {
    case idle
    case started
    case speeching
    case stopped
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
    let speechStatusSubject: CurrentValueSubject<SpeechStatus, Never> = .init(.idle)

    private var locale: Locale
    private var speechRecognizer: SFSpeechRecognizer?
    private var request: SFSpeechAudioBufferRecognitionRequest?
    private var task: SFSpeechRecognitionTask?
    private let engine: AVAudioEngine = .init()

    public init(locale: Locale) {
        self.locale = locale
        self.speechRecognizer = SFSpeechRecognizer(locale: locale)

        Task { [weak self] in
            try await self?.requestPermission()
        }
    }

    func requestPermission() async throws {
        try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<Void, Error>) in
            SFSpeechRecognizer.requestAuthorization { [weak self] status in
                guard let self else {
                    return
                }
                switch status {
                case .denied, .restricted, .notDetermined:
                    self.errorSubject.send(.missingPermission(.recognition))
                    continuation.resume(
                        with: .failure(SpeechToTextError.missingPermission(.recognition))
                    )
                case .authorized:
                    var permissions = self.permissionSubject.value
                    permissions.insert(.recognition)
                    self.permissionSubject.send(permissions)
                    continuation.resume()
                @unknown default:
                    assertionFailure()
                    break
                }
            }
        }
        try await withCheckedThrowingContinuation { [weak self] (continuation: CheckedContinuation<Void, Error>) in
            AVAudioSession.sharedInstance().requestRecordPermission { [weak self] granted in
                guard let self else {
                    return
                }
                if granted {
                    var permissions = self.permissionSubject.value
                    permissions.insert(.mic)
                    self.permissionSubject.send(permissions)
                    continuation.resume()
                } else {
                    self.errorSubject.send(.missingPermission(.mic))
                    continuation.resume(throwing: SpeechToTextError.missingPermission(.mic))
                }
            }
        }
    }

    func stream() throws {
        guard let speechRecognizer else {
            throw SpeechToTextError.invalidLocale(locale)
        }
        let session = AVAudioSession.sharedInstance()
        try session.setCategory(.record, mode: .measurement, options: .duckOthers)
        try session.setActive(true, options: .notifyOthersOnDeactivation)
        let inputNode = engine.inputNode

        // Create and configure the speech recognition request.
        request = SFSpeechAudioBufferRecognitionRequest()
        guard let request = request else {
            throw SpeechToTextError.failedPreparation
        }
        request.shouldReportPartialResults = true
        // Keep speech recognition data on device
        request.requiresOnDeviceRecognition = false

        speechStatusSubject.send(.started)

        // Create a recognition task for the speech recognition session.
        // Keep a reference to the task so that it can be canceled.
        task = speechRecognizer.recognitionTask(with: request, resultHandler: { [weak self] result, error in
            guard let self = self else {
                return
            }
            var isFinal = false

            if let result = result {
                // Update the text with the results.
                let new = SpeechToTextModel(
                    text: result.bestTranscription.formattedString,
                    isFinal: result.isFinal
                )
                self.onTextUpdateSubject.send(new)
                isFinal = result.isFinal
            }

            if error != nil || isFinal {
                // Stop recognizing speech if there is a problem.
                self.engine.stop()
                inputNode.removeTap(onBus: 0)

                self.request = nil
                self.task = nil

                self.speechStatusSubject.send(.stopped)
                self.speechStatusSubject.send(.idle)
            } else {
                self.speechStatusSubject.send(.speeching)
            }
        })
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

    public var speechStatus: AnyPublisher<SpeechStatus, Never> {
        speechStatusSubject.eraseToAnyPublisher()
    }

    public func start() async throws {
        let permission = permissionSubject.value
        if permission != [.mic, .recognition] {
            try await requestPermission()
        }
        try stream()
    }
}
