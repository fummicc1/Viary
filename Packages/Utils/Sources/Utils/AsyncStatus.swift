import Foundation

public enum AsyncStatus<Response: Equatable>: Equatable {
    public static func == (lhs: AsyncStatus<Response>, rhs: AsyncStatus<Response>) -> Bool {
        switch lhs {
        case .idle:
            if case Self.idle = rhs {
                return true
            }
        case .loading(let cache):
            if case Self.loading(let rhsCache) = rhs {
                return cache == rhsCache
            }
        case .success(let response):
            if case Self.success(let rhsResponse) = rhs {
                return response == rhsResponse
            }
        case .fail(let error):
            if case Self.fail(let rhsError) = rhs {
                return error.localizedDescription == rhsError.localizedDescription
            }
        }
        return false
    }

    case idle
    case loading(cache: Response?)
    case success(Response)
    case fail(Error)

    public var isLoading: Bool {
        if case Self.loading = self {
            return true
        }
        return false
    }

    public var response: Response? {
        switch self {
        case .success(let response):
            return response
        case .loading(let cache):
            return cache
        default:
            return nil
        }
    }

    public mutating func start() {
        var prev: Response?
        switch self {
        case .loading(let cache):
            prev = cache
        case .success(let response):
            prev = response
        default:
            break
        }
        self = .loading(cache: prev)
    }
}
