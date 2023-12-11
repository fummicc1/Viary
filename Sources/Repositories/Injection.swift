import Dependencies
import MoyaAPIClient
import XCTestDynamicOverlay

public enum ViaryRepositoryKey: DependencyKey, Sendable {
    public static let liveValue: ViaryRepository = ViaryRepositoryImpl(apiClient: AppAPIClient())
    public static var testValue: ViaryRepository = unimplemented()
}

public extension DependencyValues {
    var viaryRepository: ViaryRepository {
        get { self[ViaryRepositoryKey.self] }
        set { self[ViaryRepositoryKey.self] = newValue }
    }
}
