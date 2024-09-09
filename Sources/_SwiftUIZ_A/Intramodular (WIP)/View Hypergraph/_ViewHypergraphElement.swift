//
// Copyright (c) Vatsal Manot
//

import CorePersistence
import Runtime
import Swallow

public protocol _HeavyweightViewHypergraphElement: DynamicProperty, Identifiable {
    var _interposeContext: EnvironmentValues._InterposeGraphContext { get throws }
    
    var id: _HeavyweightViewHypergraphElementID { get }
}

public protocol _HeavyweightViewHypergraphElementRepresentingProperty: DynamicProperty, PropertyWrapper {
    
}

public protocol _HeavyweightViewHypergraphElementRepresentingPropertyKeyPath<Root>: AnyKeyPath {
    associatedtype Root: View
    associatedtype Value: _HeavyweightViewHypergraphElementRepresentingProperty
}

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

extension _HeavyweightViewHypergraphElement {
    public var _viewGraphElementID: _HeavyweightViewHypergraphElementID {
        id
    }
}

extension _HeavyweightViewHypergraphStaticElementID {
    public var graphPassUpdating: (any _HeavyweightViewHypergraphPassUpdating.Type)? {
        switch self {
            case .viewProperty(let keyPath):
                return Swift.type(of: keyPath.wrappedValue)._Swallow_KeyPathType_ValueType as? any _HeavyweightViewHypergraphPassUpdating.Type
        }
    }
}

// MARK: - Implemented Conformances

extension KeyPath: _HeavyweightViewHypergraphElementRepresentingPropertyKeyPath where Root: View, Value: _HeavyweightViewHypergraphElementRepresentingProperty {
    
}

// MARK: - Auxiliary

extension _HeavyweightViewHypergraphStaticElementID {
    public func _opaque_to_HeavyweightViewHypergraphSymbol() -> any _AnyViewHypergraph.SymbolType {
        switch self {
            case .viewProperty(let x):
                return type(of: x.wrappedValue)._opaque_to_HeavyweightViewHypergraphSymbol(self)
        }
    }
}

extension _HeavyweightViewHypergraphElementRepresentingPropertyKeyPath {
    static func _opaque_to_HeavyweightViewHypergraphSymbol(
        _ id: _HeavyweightViewHypergraphStaticElementID
    ) -> any _AnyViewHypergraph.SymbolType {
        _AnyViewHypergraph.Symbol<Value>.staticElement(id)
    }
}
