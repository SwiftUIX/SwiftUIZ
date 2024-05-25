//
// Copyright (c) Vatsal Manot
//

import Swallow
import SwiftUI

public struct _ViewTypeDescription: _DynamicViewGraphPassTarget {
    public var demands: [_AnyDynamicViewSymbol: ViewDemands] = [:]
    
    public init() {
        
    }
}

public struct ViewDemands: Initiable {
    public var _swiftType: Any.Type?
    
    public init() {
        
    }
}
