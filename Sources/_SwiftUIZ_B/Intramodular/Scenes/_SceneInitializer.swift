//
// Copyright (c) Vatsal Manot
//

import Combine
import CorePersistence
import Swallow
import SwiftUIX

public protocol _DynamicSceneInitializer {
    associatedtype ID
    associatedtype Value
    
    func resolve(
        from parameters: _SwiftUIZ_AnyDynamicSceneInitializerParameters
    ) throws -> _AnySceneContent?
}

extension _DynamicSceneInitializer {
    var _opaque_ID: Any.Type {
        ID.self
    }
    
    var _opaque_Value: Any.Type {
        Value.self
    }
}

public struct _AnyDynamicSceneInitializer: _DynamicSceneInitializer {
    public typealias ID = Any?
    public typealias Value = Any?
    
    public let base: any _DynamicSceneInitializer
    
    public init(erasing base: any _DynamicSceneInitializer) {
        self.base = base
    }
    
    public func resolve(
        from parameters: _SwiftUIZ_AnyDynamicSceneInitializerParameters
    ) throws -> _AnySceneContent? {
        try base.resolve(from: parameters)
    }
}

public struct _SwiftUIZ_AnyDynamicSceneInitializerParameters {
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

public struct _DynamicSceneInitializerGroup: Identifiable {
    public var id: AnyHashable
    public var initializers: [_AnyDynamicSceneInitializer]
    
    public init(
        id: some Hashable,
        initializers: [_AnyDynamicSceneInitializer]
    ) {
        self.id = id
        self.initializers = initializers
    }
    
    public init(
        id: some Hashable,
        @ArrayBuilder initializers: () -> [_AnyDynamicSceneInitializer]
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

public enum _DynamicSceneInitializers {
    public struct ResolvedContent<Content: View>: _DynamicSceneInitializer {
        public typealias ID = Never
        public typealias Value = Never
        
        public let content: Content
        
        public func resolve(
            from parameters: _SwiftUIZ_AnyDynamicSceneInitializerParameters
        ) throws -> _AnySceneContent? {
            guard parameters.isEmpty else {
                throw _SceneInitializationError.unusedParameters
            }
            
            return _AnySceneContent(content: content.eraseToAnyView()) // FIXME??
        }
    }
    
    public struct ValueBased<
        Value,
        Content: _SceneContent
    >: _DynamicSceneInitializer {
        public typealias ID = Never
                
        public var value: (Value) throws -> Content?
        
        public func resolve(
            from parameters: _SwiftUIZ_AnyDynamicSceneInitializerParameters
        ) throws -> _AnySceneContent? {
            guard !parameters.isEmpty else {
                throw _SceneInitializationError.missingParameter(.id)
            }
            
            try _warnOnThrow {
                try _tryAssert(parameters.idType == nil)
                try _tryAssert(parameters.id == nil)
            }
                                    
            guard let value = parameters.value as? Value else {
                throw _SceneInitializationError.invalidParameter(.value)
            }
            
            return try self.value(value).map({ _AnySceneContent(content: $0.eraseToAnyView()) })
        }
    }

    public struct IdentifierWithValue<
        ID,
        Value,
        Content: _SceneContent
    >: _DynamicSceneInitializer {
        public var id: ID
        public var value: (Value) throws -> Content?
        
        public func resolve(
            from parameters: _SwiftUIZ_AnyDynamicSceneInitializerParameters
        ) throws -> _AnySceneContent? {
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
            
            return try self.value(value).map({ _AnySceneContent(content: $0.eraseToAnyView()) })
        }
    }
    
    public struct DocumentEditor<
        Document,
        Content: View
    >: _DynamicSceneInitializer {
        public typealias ID = Never
        public typealias Value = Document
        
        public let newDocument: () -> Document
        public let content: (_FileDocumentConfiguration<Document>) -> Content
        
        public func resolve(
            from parameters: _SwiftUIZ_AnyDynamicSceneInitializerParameters
        ) throws -> _AnySceneContent? {
            guard !parameters.isEmpty else {
                throw _SceneInitializationError.missingParameters
            }
            
            assert(parameters.id == nil)
            
            // FIXME: !!!
            guard let document = parameters.value as? (any _SwiftUIX_BindingType<Document>) else {
                throw _SceneInitializationError.invalidParameter(.value)
            }
            
            let configuration = _FileDocumentConfiguration(
                document: Binding(_from: document),
                fileURL: nil,
                isEditable: true
            )
            
            return _AnySceneContent(content: self.content(configuration))
        }
    }
    
    public struct ReferenceDocumentEditor<
        Document: ObservableObject,
        Content: View
    >: _DynamicSceneInitializer {
        public typealias ID = Never
        public typealias Value = Document
        
        public let newDocument: () -> Document
        public let content: (_ReferenceFileDocumentConfiguration<Document>) -> Content
        
        public func resolve(
            from parameters: _SwiftUIZ_AnyDynamicSceneInitializerParameters
        ) throws -> _AnySceneContent? {
            guard !parameters.isEmpty else {
                throw _SceneInitializationError.missingParameters
            }
            
            assert(parameters.id == nil)
            
            // FIXME: !!!
            guard let document = parameters.value as? ObservedObject<Document> else {
                throw _SceneInitializationError.invalidParameter(.value)
            }
            
            let configuration = _ReferenceFileDocumentConfiguration(
                document: document,
                fileURL: nil,
                isEditable: true
            )
            
            return _AnySceneContent(content: self.content(configuration))
        }

    }
}
