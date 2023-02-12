import SwiftUI

public struct CloseButton: View {

    public enum `Type`: Hashable {
        case text
        case icon
    }

    public let onTap: () -> Void
    public let type: `Type`

    public init(_ type: `Type` = .icon, onTap: @escaping () -> Void) {
        self.type = type
        self.onTap = onTap
    }

    public var body: some View {
        Button {
            onTap()
        } label: {
            switch type {
            case .text:
                Text("Close")
            case .icon:
                Image(systemSymbol: .xmarkCircle)
            }
        }
    }
}
