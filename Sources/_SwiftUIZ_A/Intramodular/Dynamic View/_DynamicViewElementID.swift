//
// Copyright (c) Vatsal Manot
//

import CorePersistence
import Runtime

public protocol _ConsumableDynamicViewElementProperty {
    static var _isHiddenConsumableDynamicViewElementProperty: Bool { get }
    
    var _isAttributeResolved: Bool { get throws }
    
    @MainActor
    dynamic func __conversion(
        context: _opaque_DynamicViewGraphContextType
    ) throws -> any _ConsumableDynamicViewElementProperty
    
    @MainActor
    func _resolveShallowIdentifier(
        in context: some _opaque_DynamicViewGraphContextType
    ) throws -> _ViewAttributeID
    
    @MainActor
    func update<Context: _opaque_DynamicViewGraphContextType>(
        id: _ViewAttributeID,
        context: inout Context
    ) throws
}

extension _ConsumableDynamicViewElementProperty {
    public static var _isHiddenConsumableDynamicViewElementProperty: Bool {
        false
    }
    
    public var _isAttributeResolved: Bool {
        true
    }
}

public struct _DynamicViewElementID: IdentifierProtocol, Sendable {
    private let base = _AutoIncrementingIdentifier<Self>()
    
    public init() {
        
    }
    
    public var body: some IdentityRepresentation {
        base
    }
}

public enum _DynamicViewStaticElementID: Hashable, @unchecked Sendable {
    case viewProperty(_HashableExistential<any _DynamicViewGraphElementRepresentingPropertyKeyPath>)
    
    var _swiftType: Any.Type {
        get throws {
            switch self {
                case .viewProperty(let keyPath):
                    return Swift.type(of: keyPath.wrappedValue)._Swallow_KeyPathType_ValueType
            }
        }
    }
    
    public var graphPassUpdating: (any _DynamicViewGraphPassUpdating.Type)? {
        switch self {
            case .viewProperty(let keyPath):
                return Swift.type(of: keyPath.wrappedValue)._Swallow_KeyPathType_ValueType as? any _DynamicViewGraphPassUpdating.Type
        }
    }
}

extension _DynamicViewStaticElementID {
    public func _opaque_toDynamicViewSymbol() -> any _DynamicViewSymbolType {
        switch self {
            case .viewProperty(let x):
                return type(of: x.wrappedValue)._opaque_toDynamicViewSymbol(self)
        }
    }
}

extension TypeMetadata {
    public func _extractDynamicViewElementIDs() -> Set<_DynamicViewStaticElementID> {
        var result: Set<_DynamicViewStaticElementID> = []
        
        for keyPath in _shallow_allKeyPathsByName.values {
            if let keyPath = keyPath as? (any _DynamicViewGraphElementRepresentingPropertyKeyPath) {
                result.insert(.viewProperty(.init(wrappedValue: keyPath)))
            } else {
                // assertionFailure()
            }
        }
        
        return result
    }
}
