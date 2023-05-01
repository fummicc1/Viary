//
// emotion_english_distilroberta_base.swift
//
// This file was automatically generated and should not be edited.
//

#if CI
import CoreML


/// Model Prediction Input Type
@available(macOS 12.0, iOS 15.0, tvOS 15.0, watchOS 8.0, *)
public class emotion_english_distilroberta_baseInput : MLFeatureProvider {

    /// input_ids as 1 by 3 matrix of 32-bit integers
    public var input_ids: MLMultiArray

    /// attention_mask as 1 by 3 matrix of 32-bit integers
    public var attention_mask: MLMultiArray

    public var featureNames: Set<String> {
        get {
            return ["input_ids", "attention_mask"]
        }
    }

    public func featureValue(for featureName: String) -> MLFeatureValue? {
        if (featureName == "input_ids") {
            return MLFeatureValue(multiArray: input_ids)
        }
        if (featureName == "attention_mask") {
            return MLFeatureValue(multiArray: attention_mask)
        }
        return nil
    }

    public init(input_ids: MLMultiArray, attention_mask: MLMultiArray) {
        self.input_ids = input_ids
        self.attention_mask = attention_mask
    }

    public convenience init(input_ids: MLShapedArray<Int32>, attention_mask: MLShapedArray<Int32>) {
        self.init(input_ids: MLMultiArray(input_ids), attention_mask: MLMultiArray(attention_mask))
    }

}


/// Model Prediction Output Type
@available(macOS 12.0, iOS 15.0, tvOS 15.0, watchOS 8.0, *)
public class emotion_english_distilroberta_baseOutput : MLFeatureProvider {

    /// Source provided by CoreML
    private let provider : MLFeatureProvider

    /// inp as multidimensional array of floats
    public var inp: MLMultiArray {
        return self.provider.featureValue(for: "inp")!.multiArrayValue!
    }

    /// inp as multidimensional array of floats
    public var inpShapedArray: MLShapedArray<Float> {
        return MLShapedArray<Float>(self.inp)
    }

    public var featureNames: Set<String> {
        return self.provider.featureNames
    }

    public func featureValue(for featureName: String) -> MLFeatureValue? {
        return self.provider.featureValue(for: featureName)
    }

    public init(inp: MLMultiArray) {
        self.provider = try! MLDictionaryFeatureProvider(dictionary: ["inp" : MLFeatureValue(multiArray: inp)])
    }

    public init(features: MLFeatureProvider) {
        self.provider = features
    }
}


/// Class for model loading and prediction
@available(macOS 12.0, iOS 15.0, tvOS 15.0, watchOS 8.0, *)
public class emotion_english_distilroberta_base {
    public let model: MLModel

    /// URL of model assuming it was installed in the same bundle as this class
    class var urlOfModelInThisBundle : URL {
        let bundle = Bundle(for: Self.self)
        return bundle.url(forResource: "emotion-english-distilroberta-base", withExtension:"mlmodelc")!
    }

    /**
        Construct emotion_english_distilroberta_base instance with an existing MLModel object.

        Usually the application does not use this initializer unless it makes a subclass of emotion_english_distilroberta_base.
        Such application may want to use `MLModel(contentsOfURL:configuration:)` and `emotion_english_distilroberta_base.urlOfModelInThisBundle` to create a MLModel object to pass-in.

        - parameters:
          - model: MLModel object
    */
    init(model: MLModel) {
        self.model = model
    }

    /**
        Construct a model with configuration

        - parameters:
           - configuration: the desired model configuration

        - throws: an NSError object that describes the problem
    */
    public convenience init(configuration: MLModelConfiguration = MLModelConfiguration()) throws {
        try self.init(contentsOf: type(of:self).urlOfModelInThisBundle, configuration: configuration)
    }

    /**
        Construct emotion_english_distilroberta_base instance with explicit path to mlmodelc file
        - parameters:
           - modelURL: the file url of the model

        - throws: an NSError object that describes the problem
    */
    public convenience init(contentsOf modelURL: URL) throws {
        try self.init(model: MLModel(contentsOf: modelURL))
    }

    /**
        Construct a model with URL of the .mlmodelc directory and configuration

        - parameters:
           - modelURL: the file url of the model
           - configuration: the desired model configuration

        - throws: an NSError object that describes the problem
    */
    public convenience init(contentsOf modelURL: URL, configuration: MLModelConfiguration) throws {
        try self.init(model: MLModel(contentsOf: modelURL, configuration: configuration))
    }

    /**
        Construct emotion_english_distilroberta_base instance asynchronously with optional configuration.

        Model loading may take time when the model content is not immediately available (e.g. encrypted model). Use this factory method especially when the caller is on the main thread.

        - parameters:
          - configuration: the desired model configuration
          - handler: the completion handler to be called when the model loading completes successfully or unsuccessfully
    */
    public class func load(configuration: MLModelConfiguration = MLModelConfiguration(), completionHandler handler: @escaping (Swift.Result<emotion_english_distilroberta_base, Error>) -> Void) {
        return self.load(contentsOf: self.urlOfModelInThisBundle, configuration: configuration, completionHandler: handler)
    }

    /**
        Construct emotion_english_distilroberta_base instance asynchronously with optional configuration.

        Model loading may take time when the model content is not immediately available (e.g. encrypted model). Use this factory method especially when the caller is on the main thread.

        - parameters:
          - configuration: the desired model configuration
    */
    public class func load(configuration: MLModelConfiguration = MLModelConfiguration()) async throws -> emotion_english_distilroberta_base {
        return try await self.load(contentsOf: self.urlOfModelInThisBundle, configuration: configuration)
    }

    /**
        Construct emotion_english_distilroberta_base instance asynchronously with URL of the .mlmodelc directory with optional configuration.

        Model loading may take time when the model content is not immediately available (e.g. encrypted model). Use this factory method especially when the caller is on the main thread.

        - parameters:
          - modelURL: the URL to the model
          - configuration: the desired model configuration
          - handler: the completion handler to be called when the model loading completes successfully or unsuccessfully
    */
    public class func load(contentsOf modelURL: URL, configuration: MLModelConfiguration = MLModelConfiguration(), completionHandler handler: @escaping (Swift.Result<emotion_english_distilroberta_base, Error>) -> Void) {
        MLModel.load(contentsOf: modelURL, configuration: configuration) { result in
            switch result {
            case .failure(let error):
                handler(.failure(error))
            case .success(let model):
                handler(.success(emotion_english_distilroberta_base(model: model)))
            }
        }
    }

    /**
        Construct emotion_english_distilroberta_base instance asynchronously with URL of the .mlmodelc directory with optional configuration.

        Model loading may take time when the model content is not immediately available (e.g. encrypted model). Use this factory method especially when the caller is on the main thread.

        - parameters:
          - modelURL: the URL to the model
          - configuration: the desired model configuration
    */
    public class func load(contentsOf modelURL: URL, configuration: MLModelConfiguration = MLModelConfiguration()) async throws -> emotion_english_distilroberta_base {
        let model = try await MLModel.load(contentsOf: modelURL, configuration: configuration)
        return emotion_english_distilroberta_base(model: model)
    }

    /**
        Make a prediction using the structured interface

        - parameters:
           - input: the input to the prediction as emotion_english_distilroberta_baseInput

        - throws: an NSError object that describes the problem

        - returns: the result of the prediction as emotion_english_distilroberta_baseOutput
    */
    public func prediction(input: emotion_english_distilroberta_baseInput) throws -> emotion_english_distilroberta_baseOutput {
        return try self.prediction(input: input, options: MLPredictionOptions())
    }

    /**
        Make a prediction using the structured interface

        - parameters:
           - input: the input to the prediction as emotion_english_distilroberta_baseInput
           - options: prediction options

        - throws: an NSError object that describes the problem

        - returns: the result of the prediction as emotion_english_distilroberta_baseOutput
    */
    public func prediction(input: emotion_english_distilroberta_baseInput, options: MLPredictionOptions) throws -> emotion_english_distilroberta_baseOutput {
        let outFeatures = try model.prediction(from: input, options:options)
        return emotion_english_distilroberta_baseOutput(features: outFeatures)
    }

    /**
        Make a prediction using the convenience interface

        - parameters:
            - input_ids as 1 by 3 matrix of 32-bit integers
            - attention_mask as 1 by 3 matrix of 32-bit integers

        - throws: an NSError object that describes the problem

        - returns: the result of the prediction as emotion_english_distilroberta_baseOutput
    */
    public func prediction(input_ids: MLMultiArray, attention_mask: MLMultiArray) throws -> emotion_english_distilroberta_baseOutput {
        let input_ = emotion_english_distilroberta_baseInput(input_ids: input_ids, attention_mask: attention_mask)
        return try self.prediction(input: input_)
    }

    /**
        Make a prediction using the convenience interface

        - parameters:
            - input_ids as 1 by 3 matrix of 32-bit integers
            - attention_mask as 1 by 3 matrix of 32-bit integers

        - throws: an NSError object that describes the problem

        - returns: the result of the prediction as emotion_english_distilroberta_baseOutput
    */

    public func prediction(input_ids: MLShapedArray<Int32>, attention_mask: MLShapedArray<Int32>) throws -> emotion_english_distilroberta_baseOutput {
        let input_ = emotion_english_distilroberta_baseInput(input_ids: input_ids, attention_mask: attention_mask)
        return try self.prediction(input: input_)
    }

    /**
        Make a batch prediction using the structured interface

        - parameters:
           - inputs: the inputs to the prediction as [emotion_english_distilroberta_baseInput]
           - options: prediction options

        - throws: an NSError object that describes the problem

        - returns: the result of the prediction as [emotion_english_distilroberta_baseOutput]
    */
    public func predictions(inputs: [emotion_english_distilroberta_baseInput], options: MLPredictionOptions = MLPredictionOptions()) throws -> [emotion_english_distilroberta_baseOutput] {
        let batchIn = MLArrayBatchProvider(array: inputs)
        let batchOut = try model.predictions(from: batchIn, options: options)
        var results : [emotion_english_distilroberta_baseOutput] = []
        results.reserveCapacity(inputs.count)
        for i in 0..<batchOut.count {
            let outProvider = batchOut.features(at: i)
            let result =  emotion_english_distilroberta_baseOutput(features: outProvider)
            results.append(result)
        }
        return results
    }
}
#endif
