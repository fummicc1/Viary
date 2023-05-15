import Foundation
import Dependencies
import MoyaAPIClient

public enum Ja2EnServiceError: LocalizedError {
    case noResult(response: Ja2EnResponse)
}

public protocol Ja2EnService {
    func translate(message: String) async throws -> String
}

public class Ja2EnServiceImpl: Ja2EnService, DependencyKey {

    public static var liveValue: any Ja2EnService = Ja2EnServiceImpl()

    public func translate(message: String) async throws -> String {
        let request = Ja2EnRequest.translate(inputs: message)
        let response: Ja2EnResponse = try await request.send()
        guard let translationText = response.first?.translationText else {
            throw Ja2EnServiceError.noResult(response: response)
        }
        return translationText
    }
}

extension DependencyValues {
    public var ja2En: any Ja2EnService {
        get {
            self[Ja2EnServiceImpl.self]
        } set {
            self[Ja2EnServiceImpl.self] = newValue
        }
    }
}
