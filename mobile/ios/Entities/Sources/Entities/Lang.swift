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
}
