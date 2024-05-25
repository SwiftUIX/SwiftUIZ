//
// Copyright (c) Vatsal Manot
//

import Runtime
import SwiftUIX

extension InstanceMirror {
    // FIXME: SLOW
    @MainActor(unsafe)
    package func _collectConsumableElementProperties(
        into result: inout [any _ConsumableDynamicViewElementProperty],
        context: _opaque_DynamicViewGraphContextType
    ) throws {
        return try forEachChild(
            conformingTo: (any PropertyWrapper).self
        ) { field in
            if let fieldValue = field.value as? (any _ConsumableDynamicViewElementProperty) {
                guard !(type(of: fieldValue )._isHiddenConsumableDynamicViewElementProperty) else {
                    return
                }
                
                let attribute: any _ConsumableDynamicViewElementProperty = try fieldValue.__conversion(context: context)
                
                result.append(fieldValue)
                
                guard try attribute._isAttributeResolved else {
                    return
                }
            } else if let wrappedValue = field.value.wrappedValue as? (any ObservableObject) {
                if let mirror = InstanceMirror<Any>(wrappedValue) {
                    try mirror._collectConsumableElementProperties(into: &result, context: context)
                }
            }
        } ingoring: {
            if $0 is (any _DynamicViewGraphElementRepresentingProperty) {
                assertionFailure("Ignored \($0)")
            }
            
            _ = $0
        }
    }
}
