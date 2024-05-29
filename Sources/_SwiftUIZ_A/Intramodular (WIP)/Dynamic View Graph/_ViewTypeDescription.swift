//
// Copyright (c) Vatsal Manot
//

import Swallow
import SwiftUI

public struct _ViewTypeDescription: _DynamicViewGraphPassTarget {
    public var demands: [_AnyDynamicViewGraph.AnyViewSymbol: _DynamicViewGraphElementDemands] = [:]
    
    public init() {
        
    }
}

public struct _DynamicViewGraphElementDemands: Initiable {
    public var _swiftType: Any.Type?
    
    public init() {
        
    }
}
