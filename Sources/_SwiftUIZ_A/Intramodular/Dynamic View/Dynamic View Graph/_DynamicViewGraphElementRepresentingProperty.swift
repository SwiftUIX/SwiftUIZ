//
// Copyright (c) Vatsal Manot
//

import Swallow
import SwiftUIX

public protocol _DynamicViewGraphElementRepresentingProperty: DynamicProperty, PropertyWrapper {
    
}

public protocol _DynamicViewGraphElementRepresentingPropertyKeyPath<Root>: AnyKeyPath {
    associatedtype Root: View
    associatedtype Value: _DynamicViewGraphElementRepresentingProperty
}

extension _DynamicViewGraphElementRepresentingPropertyKeyPath {
    static func _opaque_toDynamicViewSymbol(
        _ id: _DynamicViewStaticElementID
    ) -> any _DynamicViewSymbolType {
        _DynamicViewSymbol<Value>.staticElement(id)
    }
}

extension KeyPath: _DynamicViewGraphElementRepresentingPropertyKeyPath where Root: View, Value: _DynamicViewGraphElementRepresentingProperty {
    
}
