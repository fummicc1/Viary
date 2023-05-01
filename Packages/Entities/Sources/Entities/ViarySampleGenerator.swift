import Dependencies
import Tagged

public class ViarySampleGenerator: DependencyKey {
    public static var liveValue: ViarySampleGenerator = .init()

    public init() {}

    @Dependency(\.date) var date
    @Dependency(\.uuid) var uuid

    public func make() -> Viary {
        let id: Tagged<Viary, String> = .init(uuid().uuidString)
        return Viary(
            id: id,
            messages: [
                .init(
                    viaryID: id,
                    id: .init(uuid().uuidString),
                    sentence: "This is sample viary!",
                    lang: .en,
                    updatedAt: date.now
                )
            ],
            date: date.now
        )
    }
}

extension DependencyValues {
    public var viarySample: ViarySampleGenerator {
        get {
            self[ViarySampleGenerator.self]
        }
        set {
            self[ViarySampleGenerator.self] = newValue
        }
    }
}
