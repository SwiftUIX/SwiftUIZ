//
// Copyright (c) Vatsal Manot
//

import CorePersistence
import Swallow
import SwiftUIX

public protocol _SceneInitializer {
    associatedtype ID
    associatedtype Value
    
    func resolve(
        from parameters: _SwiftUIZ_AnySceneInitializerParameters
    ) throws -> _ResolvedSceneContent?
}

extension _SceneInitializer {
    var _opaque_ID: Any.Type {
        ID.self
    }
    
    var _opaque_Value: Any.Type {
        Value.self
    }
}

public struct _AnySceneInitializer: _SceneInitializer {
    public typealias ID = Any?
    public typealias Value = Any?
    
    public let base: any _SceneInitializer
    
    public init(erasing base: any _SceneInitializer) {
        self.base = base
    }
    
    public func resolve(
        from parameters: _SwiftUIZ_AnySceneInitializerParameters
    ) throws -> _ResolvedSceneContent? {
        try base.resolve(from: parameters)
    }
}

public struct _SwiftUIZ_AnySceneInitializerParameters {
    @_HashableExistential
    public var id: Any?
    @_HashableExistential
    public var idType: Any.Type?
    @_HashableExistential
    public var value: Any?
    @_HashableExistential
    public var valueType: Any.Type?
    
    var isEmpty: Bool {
        get {
            id == nil && value == nil
        }
    }

    public init<ID, Value>(
        id: ID,
        value: Value
    ) {
        self.id = id
        self.idType = type(of: id) // FIXME
        self.value = value
        self.valueType = type(of: value) // FIXME
    }
    
    public init<Value>(
        value: Value
    ) {
        self.id = nil
        self.idType = nil
        self.value = value
        self.valueType = type(of: value) // FIXME
    }
}

public struct _SceneInitializerGroup: Identifiable {
    public var id: AnyHashable
    public var initializers: [_AnySceneInitializer]
    
    public init(
        id: some Hashable,
        initializers: [_AnySceneInitializer]
    ) {
        self.id = id
        self.initializers = initializers
    }
    
    public init(
        id: some Hashable,
        @ArrayBuilder initializers: () -> [_AnySceneInitializer]
    ) {
        self.init(id: id, initializers: initializers())
    }
}

public enum _SceneInitializationError: Error {
    public enum ParameterKind {
        case id
        case value
    }
    
    case unusedParameters
    case missingParameters
    case missingParameter(ParameterKind?)
    case invalidParameter(ParameterKind?)
}

public enum _SceneInitializers {
    public struct ResolvedContent<Content: View>: _SceneInitializer {
        public typealias ID = Never
        public typealias Value = Never
        
        public let content: Content
        
        public func resolve(
            from parameters: _SwiftUIZ_AnySceneInitializerParameters
        ) throws -> _ResolvedSceneContent? {
            guard parameters.isEmpty else {
                throw _SceneInitializationError.unusedParameters
            }
            
            return _ResolvedSceneContent(content: content.eraseToAnyView()) // FIXME??
        }
    }
    
    public struct IdentifierWithValue<
        ID,
        Value,
        Content: SceneContent
    >: _SceneInitializer {
        public var id: ID
        public var value: (Value) throws -> Content?
        
        public func resolve(
            from parameters: _SwiftUIZ_AnySceneInitializerParameters
        ) throws -> _ResolvedSceneContent? {
            guard !parameters.isEmpty else {
                throw _SceneInitializationError.missingParameter(.id)
            }
            
            guard let id = parameters.id as? ID else {
                throw _SceneInitializationError.invalidParameter(.id)
            }
            
            guard AnyEquatable.equate(id, self.id) else {
                return nil
            }
            
            guard let value = parameters.value as? Value else {
                throw _SceneInitializationError.invalidParameter(.value)
            }
            
            return try self.value(value).map({ _ResolvedSceneContent(content: $0.eraseToAnyView()) })
        }
    }
    
    public struct DocumentEditor<
        Document,
        Content: View
    >: _SceneInitializer {
        public typealias ID = Never
        public typealias Value = Document
        
        public let newDocument: () -> Document
        public let content: (_FileDocumentConfiguration<Document>) -> Content
        
        public func resolve(
            from parameters: _SwiftUIZ_AnySceneInitializerParameters
        ) throws -> _ResolvedSceneContent? {
            guard !parameters.isEmpty else {
                throw _SceneInitializationError.missingParameters
            }
            
            assert(parameters.id == nil)
            
            // FIXME!!!
            guard let document = parameters.value as? (any _SwiftUIX_BindingType<Document>) else {
                throw _SceneInitializationError.invalidParameter(.value)
            }
            
            let configuration = _FileDocumentConfiguration(
                document: Binding(_from: document),
                fileURL: nil,
                isEditable: true
            )
            
            return _ResolvedSceneContent(content: self.content(configuration))
        }
    }
    
    public struct ReferenceDocumentEditor<
        Document: ObservableObject,
        Content: View
    >: _SceneInitializer {
        public typealias ID = Never
        public typealias Value = Document
        
        public let newDocument: () -> Document
        public let content: (_ReferenceFileDocumentConfiguration<Document>) -> Content
        
        public func resolve(
            from parameters: _SwiftUIZ_AnySceneInitializerParameters
        ) throws -> _ResolvedSceneContent? {
            guard !parameters.isEmpty else {
                throw _SceneInitializationError.missingParameters
            }
            
            assert(parameters.id == nil)
            
            // FIXME!!!
            guard let document = parameters.value as? ObservedObject<Document> else {
                throw _SceneInitializationError.invalidParameter(.value)
            }
            
            let configuration = _ReferenceFileDocumentConfiguration(
                document: document,
                fileURL: nil,
                isEditable: true
            )
            
            return _ResolvedSceneContent(content: self.content(configuration))
        }

    }
}
