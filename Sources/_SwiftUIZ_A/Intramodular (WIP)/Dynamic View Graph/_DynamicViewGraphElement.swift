//
// Copyright (c) Vatsal Manot
//

import CorePersistence
import Swallow

public protocol _DynamicViewGraphElement: DynamicProperty, Identifiable {
    var _interposeContext: EnvironmentValues._InterposeContext { get throws }
    
    var id: _DynamicViewElementID { get }
}

extension _DynamicViewGraphElement {
    public var _viewGraphElementID: _DynamicViewElementID {
        id
    }
}
