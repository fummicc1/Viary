import Dependencies
import MoyaAPIClient

public enum ViaryRepositoryKey: DependencyKey {
    public static let liveValue: ViaryRepository = ViaryRepositoryImpl(apiClient: APIClientImpl())
}

public extension DependencyValues {
    var viaryRepository: ViaryRepository {
        get { self[ViaryRepositoryKey.self] }
        set { self[ViaryRepositoryKey.self] = newValue }
    }
}
