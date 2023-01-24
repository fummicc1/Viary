import Dependencies
import MoyaAPIClient
import XCTestDynamicOverlay

public enum ViaryRepositoryKey: DependencyKey {
    public static let liveValue: ViaryRepository = ViaryRepositoryImpl(apiClient: APIClientImpl())
    public static var testValue: ViaryRepository = unimplemented()
}

public extension DependencyValues {
    var viaryRepository: ViaryRepository {
        get { self[ViaryRepositoryKey.self] }
        set { self[ViaryRepositoryKey.self] = newValue }
    }
}
