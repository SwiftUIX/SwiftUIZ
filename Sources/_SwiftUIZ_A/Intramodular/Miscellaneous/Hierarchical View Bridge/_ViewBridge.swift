//
// Copyright (c) Vatsal Manot
//

import Swallow
import SwiftUI

@propertyWrapper
public struct _ViewBridge<T: _HierarchicalViewBridgeType>: DynamicProperty {
    @Environment(\.[_viewBridgeType: Metatype(T.InstanceType.self)]) var _bridge: Weak<T.InstanceType>
    
    public var wrappedValue: T {
        _bridge.wrappedValue as! T
    }
    
    public init(_: T.Type) {
        
    }
}
