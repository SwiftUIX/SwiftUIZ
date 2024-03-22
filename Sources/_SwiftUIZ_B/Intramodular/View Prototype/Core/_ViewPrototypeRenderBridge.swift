//
// Copyright (c) Vatsal Manot
//

import SwiftUI

package class _ViewPrototypeRenderBridge: _HierarchicalViewBridge<_DynamicViewBridgeProtocol> {
    
}

extension EnvironmentValues {
    package var _viewRenderBridgeBox: Weak<_ViewPrototypeRenderBridge>? {
        self[_viewBridgeType: Metatype(_ViewPrototypeRenderBridge.self)]
    }
}
