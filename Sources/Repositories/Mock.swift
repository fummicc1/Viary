///
/// @Generated by Mockolo
///



import Dependencies
import Entities
import Foundation
import IdentifiedCollections
import LocalDataStore
import MoyaAPIClient
import Tagged

//
//public class ViaryRepositoryMock: ViaryRepository {
//    public init() { }
//
//
//    public private(set) var myViariesSetCallCount = 0
//    private var _myViaries: AnyPublisher<IdentifiedArrayOf<Viary>, Never>!  { didSet { myViariesSetCallCount += 1 } }
//    public var myViaries: AnyPublisher<IdentifiedArrayOf<Viary>, Never> {
//        get { return _myViaries }
//        set { _myViaries = newValue }
//    }
//
//    public private(set) var loadCallCount = 0
//    public var loadHandler: (() async throws -> (IdentifiedArrayOf<Viary>))?
//    public func load() async throws -> IdentifiedArrayOf<Viary> {
//        loadCallCount += 1
//        if let loadHandler = loadHandler {
//            return try await loadHandler()
//        }
//        fatalError("loadHandler returns can't have a default value thus its handler must be set")
//    }
//
//    public private(set) var createCallCount = 0
//    public var createHandler: ((Viary) async throws -> ())?
//    public func create(viary: Viary) async throws  {
//        createCallCount += 1
//        if let createHandler = createHandler {
//            try await createHandler(viary)
//        }
//        
//    }
//
//    public private(set) var createViaryCallCount = 0
//    public var createViaryHandler: ((Viary, [Viary.Message.ID: [Emotion.Kind: Emotion]]) async throws -> ())?
//    public func create(viary: Viary, with emotions: [Viary.Message.ID: [Emotion.Kind: Emotion]]) async throws  {
//        createViaryCallCount += 1
//        if let createViaryHandler = createViaryHandler {
//            try await createViaryHandler(viary, emotions)
//        }
//        
//    }
//
//    public private(set) var updateCallCount = 0
//    public var updateHandler: ((Tagged<Viary, String>, Viary) async throws -> ())?
//    public func update(id: Tagged<Viary, String>, viary: Viary) async throws  {
//        updateCallCount += 1
//        if let updateHandler = updateHandler {
//            try await updateHandler(id, viary)
//        }
//        
//    }
//
//    public private(set) var deleteCallCount = 0
//    public var deleteHandler: ((Tagged<Viary, String>) async throws -> ())?
//    public func delete(id: Tagged<Viary, String>) async throws  {
//        deleteCallCount += 1
//        if let deleteHandler = deleteHandler {
//            try await deleteHandler(id)
//        }
//        
//    }
//}
//
