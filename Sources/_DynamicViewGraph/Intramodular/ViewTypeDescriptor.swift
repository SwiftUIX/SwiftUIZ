//
// Copyright (c) Vatsal Manot
//

import Runtime
import Swallow
@_spi(Internal) import SwiftUIX

public struct ViewDescriptorCreateContext {
    public let view: InstanceMirror<any View>
}


package protocol ViewTypeDescriptorKey<Value>: HeterogeneousDictionaryKey where Self.Domain == ViewTypeDescriptor {
    static var defaultValue: Value { get }
}


extension ViewTypeDescriptorKey where Value: Initiable {
    package static var defaultValue: Value {
        Value()
    }
}

package struct ViewTypeDescriptor {
    public let type: TypeMetadata
    public var base = HeterogeneousDictionary<ViewTypeDescriptor>()
        
    public subscript<Key: ViewTypeDescriptorKey>(_ key: Key.Type) -> Key.Value {
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
        let view = try InstanceMirror<any View>(reflecting: view)
        let context = ViewDescriptorCreateContext(view: view)
                        
        self.type = TypeMetadata(Swift.type(of: view))

        let attributeDescriptors: [any ViewTypeDescriptorUpdater.Type] = try TypeMetadata._queryAll(
            .conformsTo((any ViewTypeDescriptorUpdater).self),
            .nonAppleFramework,
            .pureSwift
        )
        
        for descriptor in attributeDescriptors {
            try descriptor.update(&self, context: context)
        }
    }
}


package protocol ViewTypeDescriptorUpdater {
    static func update(
        _ descriptor: inout ViewTypeDescriptor,
        context: ViewDescriptorCreateContext
    ) throws
}


extension ViewTypeDescriptor {
    
}

extension _GenericHeterogeneousDictionaryKey: ViewTypeDescriptorKey where Self.Domain == ViewTypeDescriptor, Self.Value: Initiable {
    package static var defaultValue: Value {
        Value()
    }
}
