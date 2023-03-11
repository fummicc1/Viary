import Foundation

public enum Lang: String, Identifiable, Equatable, ExpressibleByStringLiteral, CaseIterable {
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
        let region: String
        if let _region = Calendar.current.locale?.identifier.suffix(2) {
            region = String(describing: _region)
        } else {
            region = "JP"
        }
        switch self {
        case .ja:
            return Locale(identifier: "ja_\(region)")
        case .en:
            return Locale(identifier: "en_\(region)")
        }
    }
}
