//
// Copyright (c) Vatsal Manot
//

import Runtime
import Swallow
@_spi(Internal) import SwiftUIX

public struct _StaticViewTypeDescriptor {
    public let type: TypeMetadata
    public var base = HeterogeneousDictionary<_StaticViewTypeDescriptor>()
    public var symbols: Set<_HeavyweightViewHypergraphStaticElementID>
    
    public init<V: View>(
        from view: V.Type
    ) throws {
        self.type = TypeMetadata(view)
        self.symbols = type._extractDynamicViewElementIDs()
    }
    
    public mutating func update(from view: any View) throws {
        assert(Swift.type(of: view) == type.base)
        
        let view = try InstanceMirror(reflecting: view)
        let context = _StaticViewTypeDescriptor.UpdateContext(view: view)
        
        let descriptorUpdatingTypes: [any _StaticViewTypeDescriptor.StaticUpdater.Type] = try TypeMetadata._queryAll(
            .conformsTo((any _StaticViewTypeDescriptor.StaticUpdater).self),
            .nonAppleFramework,
            .pureSwift
        )
        
        for descriptorUpdatingType in descriptorUpdatingTypes {
            try descriptorUpdatingType.update(&self, context: context)
        }
    }
    
    public subscript<Key: _StaticViewTypeDescriptorKey>(
        _ key: Key.Type
    ) -> Key.Value {
        get {
            self.base[key] ?? Key.defaultValue
        } set {
            self.base[key] = newValue
        }
    }
    
    public subscript<T: Initiable>(
        _ type: T.Type
    ) -> T {
        get {
            self[_GenericHeterogeneousDictionaryKey<Self, T>.self]
        } set {
            self[_GenericHeterogeneousDictionaryKey<Self, T>.self] = newValue
        }
    }
}

// MARK: - Conformances

extension _StaticViewTypeDescriptor: Identifiable {
    public var id: AnyHashable {
        type
    }
}

// MARK: - Auxiliary

extension _StaticViewTypeDescriptor {
    public struct UpdateContext {
        public let view: InstanceMirror<any View>
    }
}

extension TypeMetadata {
    fileprivate func _extractDynamicViewElementIDs() -> Set<_HeavyweightViewHypergraphStaticElementID> {
        var result: Set<_HeavyweightViewHypergraphStaticElementID> = []
        
        for keyPath in _shallow_allKeyPathsByName.values {
            if let keyPath = keyPath as? (any _HeavyweightViewHypergraphElementRepresentingPropertyKeyPath) {
                result.insert(.viewProperty(.init(wrappedValue: keyPath)))
            } else {
                // assertionFailure()
            }
        }
        
        return result
    }
}
