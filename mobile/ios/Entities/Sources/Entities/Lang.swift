public enum Lang: String, ExpressibleByStringLiteral {
    case ja
    case en

    public init(stringLiteral value: StringLiteralType) {
        if value == "ja" {
            self = .ja
        } else {
            self = .en
        }
    }
}
