import AVFoundation
import Foundation
import Speech
import AsyncExtensions

/// @mockable
public protocol SpeechToTextService: Actor {

    var onTextUpdate: AsyncStream<SpeechToTextModel> { get }
    var permission: AsyncStream<SpeechPermission> { get }
    var error: AsyncStream<SpeechToTextError> { get }
    var speechStatus: AsyncStream<SpeechStatus> { get }

    func change(locale: Locale) async throws
    func start() async throws
    func stop() async throws
}

public enum SpeechToTextError: Sendable, LocalizedError {
    case invalidLocale(Locale)
    case missingPermission(SpeechPermission)
    case failedPreparation
    case unSupportedLocale(Locale)
}

public enum SpeechStatus: Sendable, Hashable, Equatable {
    case idle
    case started
    case speeching(SpeechToTextModel)
    case stopped(SpeechToTextModel)

    mutating public func setModel(_ model: SpeechToTextModel) {
        switch self {
        case .idle, .started:
            break
        case .speeching:
            self = .speeching(model)
        case .stopped:
            self = .stopped(model)
        }
    }
}

public struct SpeechPermission: Sendable, OptionSet {

    public typealias RawValue = UInt

    public var rawValue: UInt

    static public let mic: SpeechPermission = .init(rawValue: 1 << 0)
    static public let recognition: SpeechPermission = .init(rawValue: 1 << 1)

    public init(rawValue: UInt) {
        self.rawValue = rawValue
    }
}

public struct SpeechToTextModel: Sendable, Equatable, Hashable {
    public var text: String
    public var isFinal: Bool

    public init(text: String, isFinal: Bool) {
        self.isFinal = isFinal
        self.text = text
    }
}

public final actor SpeechToTextServiceImpl {
    let onTextUpdateSubject: AsyncCurrentValueSubject<SpeechToTextModel> = .init(SpeechToTextModel(text: "", isFinal: false))
    let permissionSubject: AsyncCurrentValueSubject<SpeechPermission> = .init([])
    let errorSubject: AsyncPassthroughSubject<SpeechToTextError> = .init()
    let speechStatusSubject: AsyncCurrentValueSubject<SpeechStatus> = .init(.idle)

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

    func stream() async throws {
        guard let speechRecognizer else {
            throw SpeechToTextError.invalidLocale(locale)
        }
        guard SFSpeechRecognizer.supportedLocales().contains(locale) else {
            throw SpeechToTextError.unSupportedLocale(locale)
        }
        let session = AVAudioSession.sharedInstance()
        try session.setCategory(
            .playAndRecord,
            mode: .measurement,
            options: [.duckOthers, .allowBluetooth, .allowBluetoothA2DP, .defaultToSpeaker]
        )
        try session.setActive(true, options: .notifyOthersOnDeactivation)
        let inputNode = engine.inputNode

        speechStatusSubject.send(.started)

        if task != nil {
            stop()
        }

        // Create and configure the speech recognition request.
        request = SFSpeechAudioBufferRecognitionRequest()
        guard let request = request else {
            throw SpeechToTextError.failedPreparation
        }
        request.shouldReportPartialResults = true
        request.requiresOnDeviceRecognition = false

        // Create a recognition task for the speech recognition session.
        // Keep a reference to the task so that it can be canceled.
        task = speechRecognizer.recognitionTask(with: request, resultHandler: { [weak self] result, error in
            guard let self = self else {
                return
            }

            if let result = result {
                // Update the text with the results.
                let new = SpeechToTextModel(
                    text: result.bestTranscription.formattedString,
                    isFinal: result.isFinal
                )
                self.onTextUpdateSubject.send(new)
                self.speechStatusSubject.send(.speeching(new))
            }

            if error != nil {
                // Stop recognizing speech if there is a problem.
                stop()
            }
        })

        let recordingFormat = inputNode.outputFormat(forBus: 0)
        inputNode.removeTap(onBus: 0)
        inputNode.installTap(
            onBus: 0,
            bufferSize: AVAudioFrameCount(recordingFormat.sampleRate),
            format: recordingFormat
        ) { [weak self] (buffer: AVAudioPCMBuffer, when: AVAudioTime) in
            self?.request?.append(buffer)
        }
        if !engine.isRunning {
            engine.prepare()
            try engine.start()
        }
    }

    func stopIfNeeded() {
        switch task?.state {
        case .starting, .running:
            stop()
        default:
            break
        }
    }
}

extension SpeechToTextServiceImpl: SpeechToTextService {

    public var onTextUpdate: AsyncStream<SpeechToTextModel> {
        onTextUpdateSubject.eraseToStream()
    }

    public var permission: AsyncStream<SpeechPermission> {
        permissionSubject.eraseToStream()
    }

    public var error: AsyncStream<SpeechToTextError> {
        errorSubject.eraseToStream()
    }

    public var speechStatus: AsyncStream<SpeechStatus> {
        speechStatusSubject.eraseToStream()
    }

    public func change(locale: Locale) async throws {
        stopIfNeeded()
        self.locale = locale
        speechRecognizer = SFSpeechRecognizer(locale: locale)
    }

    public func start() async throws {
        let permission = permissionSubject.value
        if permission != [.mic, .recognition] {
            try await requestPermission()
        }
        stopIfNeeded()
        try await stream()
    }

    public func stop() {
        // Stop recognizing speech
        engine.stop()
        engine.inputNode.removeTap(onBus: 0)
        task?.cancel()
        task?.finish()

        request = nil
        task = nil

        speechStatusSubject.send(.stopped(onTextUpdateSubject.value))
        speechStatusSubject.send(.idle)
    }
}
