import CoreML
import Resources

public class Ja2en {

    public var model: opus_mt_ja_en
    let tokenizer: MarianTokenizer

    public init() {
        let vocabURL = try! Bundle.main.url(
            forResource: "vocab_ja2en",
            withExtension: "json"
        )!
        let vocab = try! JSONSerialization.jsonObject(
            with: try! Data(contentsOf: vocabURL)
        ) as! [String: Int]
        tokenizer = MarianTokenizer(vocab: vocab)
        model = try! .init()
    }

    private func multiArrayToArray(_ multiArray: MLMultiArray) -> [String] {
        let length = multiArray.count
        var ret: [String] = []
        for i in 0..<length {
            ret.append(multiArray[i].stringValue)
        }
        return ret
    }

    public func perform(japanese: String) -> [String] {
        let input_encoder_array = tokenizer.encode(text: japanese, maxLength: 512)

        let inputEncoder = try! MLMultiArray(shape: [1, input_encoder_array.count as NSNumber], dataType: .int32)

        for (i, input) in input_encoder_array.enumerated() {
            inputEncoder[i] = input as NSNumber
        }

        let inputDecoder = try! MLMultiArray(shape: [1, 1], dataType: .int32)
        inputDecoder[0] = 0

        let input = opus_mt_ja_enInput(
            input_encoder: inputEncoder,
            input_decoder: inputDecoder
        )
        let ret = try! model.prediction(input: input)
        let translation = multiArrayToArray(ret.var_1545)
        return translation
    }
}
