//
// Copyright (c) Vatsal Manot
//

import SwiftUI

@_spi(Internal)
public class _ViewPrototypeRenderBridge: _HierarchicalViewBridge<_DVHierarchicalViewBridge> {
    
}

@_spi(Internal)
extension EnvironmentValues {
    public var _viewRenderBridgeBox: Weak<_ViewPrototypeRenderBridge>? {
        self[_viewBridgeType: Metatype(_ViewPrototypeRenderBridge.self)]
    }
}
