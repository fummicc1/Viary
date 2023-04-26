import SwiftUI

public extension Color {
    static var textColor: Color {
        if UITraitCollection.current.userInterfaceStyle == .dark {
            return .white
        }
        return .black
    }
}
