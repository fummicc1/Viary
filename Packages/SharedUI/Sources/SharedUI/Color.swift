import SwiftUI

public extension Color {
    static var textColor: Color {
        if UITraitCollection.current.userInterfaceStyle == .dark {
            return .white
        }
        return .black
    }

    static var backgroundColor: Color {
        if UITraitCollection.current.userInterfaceStyle == .dark {
            return Color(UIColor.black)
        } else {
            return Color(UIColor.white)
        }
    }

    static var secondaryBackgroundColor: Color {
        Color(UIColor.secondarySystemBackground)
    }
}
