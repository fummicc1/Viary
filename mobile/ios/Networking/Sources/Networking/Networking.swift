import Foundation
import Moya

public protocol APIClient<Target> {
    associatedtype Target: TargetType
    func request<Response: Decodable>(with target: Target) async throws -> Response
    func request(with target: Target) async throws
}

public enum APIClientError: Error {
    case invalidResponse(data: Data)
    case faildToDecodeCodable(json: [String: String])
    case underlying(Error)
}

public struct APIClientImpl<Target: TargetType> {
    private var provider: MoyaProvider<Target>
    private let jsonDecoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }()

    public init(provider: MoyaProvider<Target> = .init()) {
        self.provider = provider
    }

    public static func stub() -> Self {
        APIClientImpl(
            provider: MoyaProvider<Target>(
                stubClosure: MoyaProvider.immediatelyStub
            )
        )
    }
}

extension APIClientImpl: APIClient {

    public func request<Response>(with target: Target) async throws -> Response where Response : Decodable {
        let response: Response = try await withCheckedThrowingContinuation { continuation in
            provider.request(target) { result in
                switch result {
                case .failure(let error):
                    continuation.resume(throwing: APIClientError.underlying(error))
                case .success(let response):
                    do {
                        let codableResponse = try jsonDecoder.decode(Response.self, from: response.data)
                        continuation.resume(returning: codableResponse)
                    }
                    catch {
                        continuation.resume(throwing: APIClientError.underlying(error))
                    }
                }
            }
        }
        return response
    }

    public func request(with target: Target) async throws {
        let _: Void = try await withCheckedThrowingContinuation({ continuation in
            provider.request(target) { result in
                switch result {
                case .failure(let error):
                    continuation.resume(throwing: APIClientError.underlying(error))
                case .success:
                    continuation.resume(returning: ())
                }
            }
        })
    }

}
