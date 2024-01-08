import SwiftUI

public struct Grabbar: View {
	public var body: some View {
		Capsule()
			.fill(Color.primary)
				.frame(width: 30, height: 9)
				.padding(10)
	}

	public init() {}
}
