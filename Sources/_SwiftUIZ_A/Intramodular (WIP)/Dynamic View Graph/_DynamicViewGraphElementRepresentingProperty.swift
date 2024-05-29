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
    static func _opaque_toDynamicViewGraphViewSymbol(
        _ id: _DynamicViewStaticElementID
    ) -> any _AnyDynamicViewGraph.ViewSymbolType {
        _AnyDynamicViewGraph.ViewSymbol<Value>.staticElement(id)
    }
}

extension KeyPath: _DynamicViewGraphElementRepresentingPropertyKeyPath where Root: View, Value: _DynamicViewGraphElementRepresentingProperty {
    
}
