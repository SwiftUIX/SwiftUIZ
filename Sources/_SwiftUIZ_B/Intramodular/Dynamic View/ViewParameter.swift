//
// Copyright (c) Vatsal Manot
//

import Swallow
import SwiftUI

protocol _ViewParameterType: DynamicProperty, PropertyWrapper {
    var id: AnyHashable? { get }
    var key: PartialKeyPath<_SwiftUIZ_DynamicViewParameterKeys> { get }
}

@propertyWrapper
public struct _ViewParameter<Value>: _ViewParameterType {
    @Environment(\._dynamicViewProvisioningContext) var _dynamicViewProvisioningContext
    
    @State var id: AnyHashable? = UUID()
    let key: PartialKeyPath<_SwiftUIZ_DynamicViewParameterKeys>
    
    public var wrappedValue: Value {
        let key = _SwiftUIZ_DynamicViewContentProvisioningContext.ParameterKey(key: key, id: id!)
        
        return _dynamicViewProvisioningContext.parameterValues[key] as! Value
    }
    
    public init<Key: _SwiftUIZ_DynamicViewParameterKey>(
        _ key: KeyPath<_SwiftUIZ_DynamicViewParameterKeys, Key>
    ) where Value == Key.Value {
        self.key = key
    }
    
    public init<T>(_ type: T.Type) where Value == T? {
        self.key = \_SwiftUIZ_DynamicViewParameterKeys.[Metatype(T.self)]
    }
}
