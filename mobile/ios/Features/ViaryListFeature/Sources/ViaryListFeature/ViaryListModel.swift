import SwiftUI
import Dependencies
import Entities
import Repositories
import IdentifiedCollections

public final class ViaryListModel: ObservableObject {
    @Published private(set) var viaries: IdentifiedArrayOf<Viary>
    @Dependency(\.viaryRepository) var viaryRepository

    public init(viaries: IdentifiedArrayOf<Viary>) {
        self.viaries = viaries
    }

    func loadStatus() async {
        do {
            try await viaryRepository.load()
        } catch {

        }
    }
}
