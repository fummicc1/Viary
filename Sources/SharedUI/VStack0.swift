import SwiftUI

public struct VStack0<Content: View>: View {

	public var alignment: HorizontalAlignment
	public var spacing: Double = 0
	@ViewBuilder
	public var content: () -> Content

	public var body: some View {
		VStack(alignment: alignment, spacing: spacing, content: content)
	}

	public init(alignment: HorizontalAlignment = .center, @ViewBuilder content: @escaping () -> Content) {
		self.alignment = alignment
		self.content = content
	}
}
