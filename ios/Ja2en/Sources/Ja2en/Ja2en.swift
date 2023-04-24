import CoreML
import Resources

public struct Ja2en {

    public var model: opus_mt_ja_en

    public init() {
        model = try! .init()
    }
}
