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

    public static var liveValue: Ja2EnServiceImpl = .init()

    public func translate(message: String) async throws -> String {
        let request = Ja2EnRequest.translate(inputs: message)
        let response: Ja2EnResponse = try await request.send()
        guard let translationText = response.first?.translationText else {
            throw Ja2EnServiceError.noResult(response: response)
        }
        return translationText
    }
}
