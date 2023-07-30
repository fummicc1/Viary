import Entities
import Foundation
import Moya
import MoyaAPIClient

public enum APIRequest: Sendable {
    case text2emotion(text: String, lang: Lang)
}

extension APIRequest: APITarget {
    public var baseURL: URL {
        URL(string: "https://voice-diary.net")!
    }

    public var path: String {
        switch self {
        case .text2emotion:
            return "text2emotion"
        }
    }

    public var method: Moya.Method {
        switch self {
        case .text2emotion:
            return .get
        }
    }

    public var task: Moya.Task {
        switch self {
        case let .text2emotion(text, lang):
            return .requestParameters(
                parameters: [
                    "lang": lang,
                    "text": text
                ],
                encoding: URLEncoding.default
            )
        }
    }

    public var headers: [String : String]? {
        nil
    }


}
