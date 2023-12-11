//
//  Request.swift
//  
//
//  Created by Fumiya Tanaka on 2023/05/13.
//

import Foundation
import MoyaAPIClient
import Moya

public enum Ja2EnRequest: APITarget {

    case translate(inputs: String)

    public var baseURL: URL {
        URL(string: "https://api-inference.huggingface.co/models/Helsinki-NLP/opus-mt-ja-en")!
    }

    public var path: String {
        ""
    }

    public var method: Moya.Method {
        .post
    }

    public var task: Moya.Task {
        switch self {
        case .translate(let inputs):
            let encodable: [String: String] = [
                "inputs": inputs
            ]
            return .requestJSONEncodable(encodable)
        }
    }

    public var headers: [String : String]? {
        ["Authorization": "Bearer \(apiKey)"]
    }

}

public typealias Ja2EnResponse = Array<Ja2EnResponseElement>

public struct Ja2EnResponseElement: Sendable, Decodable {
    public var translationText: String
}
