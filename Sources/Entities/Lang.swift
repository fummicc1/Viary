import Foundation

public enum Lang: String, Identifiable, Hashable, ExpressibleByStringLiteral, CaseIterable, Sendable {
    case ja
    case en

    public init(stringLiteral value: StringLiteralType) {
        if value == "ja" {
            self = .ja
        } else {
            self = .en
        }
    }

    public var displayName: String {
        switch self {
        case .ja:
            return "Japanese"
        case .en:
            return "English"
        }
    }

    public var id: String {
        rawValue
    }

    public var locale: Locale {
        switch self {
        case .ja:
            return Locale(identifier: "ja-JP")
        case .en:
            return Locale(identifier: "en-US")
        }
    }

    public func next() -> Lang {
        switch self {
        case .ja:
            return .en
        case .en:
            return .ja
        }
    }
}
