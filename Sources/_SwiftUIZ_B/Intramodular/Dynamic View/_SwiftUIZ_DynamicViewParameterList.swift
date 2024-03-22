//
// Copyright (c) Vatsal Manot
//

import Swallow
import SwiftUI

public struct _SwiftUIZ_DynamicViewParameterList: Initiable {
    var storage: [PartialKeyPath<_SwiftUIZ_DynamicViewParameterKeys>: Any] = [:]
    
    public init() {
        
    }
    
    public subscript<Key: _SwiftUIZ_DynamicViewParameterKey>(
        _ keyPath: KeyPath<_SwiftUIZ_DynamicViewParameterKeys, Key>
    ) -> Key.Value? {
        get {
            storage[keyPath].map({ $0 as! Key.Value })
        } set {
            storage[keyPath] = newValue
        }
    }
    
    public subscript<T>(
        _ type: T.Type
    ) -> T? {
        get {
            storage[\_SwiftUIZ_DynamicViewParameterKeys.[Metatype(type)]].map({ $0 as! T })
        } set {
            storage[\_SwiftUIZ_DynamicViewParameterKeys.[Metatype(type)]] = newValue
        }
    }
}
