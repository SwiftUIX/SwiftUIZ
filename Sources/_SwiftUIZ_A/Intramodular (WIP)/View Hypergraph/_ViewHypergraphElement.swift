//
// Copyright (c) Vatsal Manot
//

import CorePersistence
import Runtime
import Swallow

public struct _HeavyweightViewHypergraphElementID: IdentifierProtocol, Sendable {
    private let base = _AutoIncrementingIdentifier<Self>()
    
    public init() {
        
    }
    
    public var body: some IdentityRepresentation {
        base
    }
}

public enum _HeavyweightViewHypergraphStaticElementID: Hashable, @unchecked Sendable {
    case viewProperty(_HashableExistential<any _HeavyweightViewHypergraphElementRepresentingPropertyKeyPath>)
    
    var _swiftType: Any.Type {
        get throws {
            switch self {
                case .viewProperty(let keyPath):
                    return Swift.type(of: keyPath.wrappedValue)._Swallow_KeyPathType_ValueType
            }
        }
    }
}

public protocol _HeavyweightViewHypergraphElement: DynamicProperty, Identifiable {
    var _interposeContext: EnvironmentValues._InterposeContext { get throws }
    
    var id: _HeavyweightViewHypergraphElementID { get }
}

extension _HeavyweightViewHypergraphElement {
    public var _viewGraphElementID: _HeavyweightViewHypergraphElementID {
        id
    }
}

public protocol _HeavyweightViewHypergraphElementRepresentingProperty: DynamicProperty, PropertyWrapper {
    
}

public protocol _HeavyweightViewHypergraphElementRepresentingPropertyKeyPath<Root>: AnyKeyPath {
    associatedtype Root: View
    associatedtype Value: _HeavyweightViewHypergraphElementRepresentingProperty
}

extension _HeavyweightViewHypergraphElementRepresentingPropertyKeyPath {
    static func _opaque_to_HeavyweightViewHypergraphSymbol(
        _ id: _HeavyweightViewHypergraphStaticElementID
    ) -> any _AnyViewHypergraph.SymbolType {
        _AnyViewHypergraph.Symbol<Value>.staticElement(id)
    }
}

extension KeyPath: _HeavyweightViewHypergraphElementRepresentingPropertyKeyPath where Root: View, Value: _HeavyweightViewHypergraphElementRepresentingProperty {
    
}

extension _HeavyweightViewHypergraphStaticElementID {
    public var graphPassUpdating: (any _HeavyweightViewHypergraphPassUpdating.Type)? {
        switch self {
            case .viewProperty(let keyPath):
                return Swift.type(of: keyPath.wrappedValue)._Swallow_KeyPathType_ValueType as? any _HeavyweightViewHypergraphPassUpdating.Type
        }
    }
}

extension _HeavyweightViewHypergraphStaticElementID {
    public func _opaque_to_HeavyweightViewHypergraphSymbol() -> any _AnyViewHypergraph.SymbolType {
        switch self {
            case .viewProperty(let x):
                return type(of: x.wrappedValue)._opaque_to_HeavyweightViewHypergraphSymbol(self)
        }
    }
}
