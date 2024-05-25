//
// Copyright (c) Vatsal Manot
//

import CorePersistence
import Swallow

public protocol _DynamicViewGraphElement: DynamicProperty, Identifiable {
    var _viewGraphContext: _DynamicViewGraphContext { get throws }
    
    var id: _DynamicViewElementID { get }
}

extension _DynamicViewGraphElement {
    public var _viewGraphElementID: _DynamicViewElementID {
        id
    }
}
