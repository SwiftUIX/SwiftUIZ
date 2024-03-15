//
// Copyright (c) Vatsal Manot
//

import Runtime
import Swallow
@_spi(Internal) import SwiftUIX


public struct _DVDescriptorCreateContext {
    let view: AnyNominalOrTupleMirror<any View>
}


public protocol _DVViewTypeDescriptorKey<Value>: HeterogeneousDictionaryKey where Self.Domain == _DVViewTypeDescriptor {
    static var defaultValue: Value { get }
}


extension _DVViewTypeDescriptorKey where Value: Initiable {
    public static var defaultValue: Value {
        Value()
    }
}

@frozen
public struct _DVViewTypeDescriptor {
    public let type: TypeMetadata
    public var base = HeterogeneousDictionary<_DVViewTypeDescriptor>()
        
    public subscript<Key: _DVViewTypeDescriptorKey>(_ key: Key.Type) -> Key.Value {
        get {
            self.base[key] ?? Key.defaultValue
        } set {
            self.base[key] = newValue
        }
    }
    
    public subscript<T: Initiable>(_ type: T.Type) -> T {
        get {
            self[_GenericHeterogeneousDictionaryKey<Self, T>.self]
        } set {
            self[_GenericHeterogeneousDictionaryKey<Self, T>.self] = newValue
        }
    }
    
    public init(
        from view: some View
    ) throws {
        let view = try AnyNominalOrTupleMirror<any View>(reflecting: view)
        let context = _DVDescriptorCreateContext(view: view)
                        
        self.type = TypeMetadata(Swift.type(of: view))

        let attributeDescriptors: [any _DVViewTypeDescriptorFilling.Type] = try TypeMetadata._queryAll(
            .conformsTo((any _DVViewTypeDescriptorFilling).self),
            .nonAppleFramework,
            .pureSwift
        )
        
        for descriptor in attributeDescriptors {
            try descriptor.update(&self, context: context)
        }
    }
}


public protocol _DVViewTypeDescriptorFilling {
    static func update(
        _ descriptor: inout _DVViewTypeDescriptor,
        context: _DVDescriptorCreateContext
    ) throws
}


extension _DVViewTypeDescriptor {
    
}

extension _GenericHeterogeneousDictionaryKey: _DVViewTypeDescriptorKey where Self.Domain == _DVViewTypeDescriptor, Self.Value: Initiable {
    public static var defaultValue: Value {
        Value()
    }
}
