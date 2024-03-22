//
// Copyright (c) Vatsal Manot
//

import SwiftUI

package class _ViewPrototypeContext: _HierarchicalViewBridge<_ViewPrototypeContext> {
    
}

package class _ViewPrototypeRootContext: _ViewPrototypeContext {
    
}

extension EnvironmentValues {
    package var _viewPrototypeContextBox: Weak<_ViewPrototypeContext>? {
        self[_viewBridgeType: Metatype(_ViewPrototypeContext.self)]
    }
}
