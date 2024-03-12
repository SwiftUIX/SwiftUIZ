//
// Copyright (c) Vatsal Manot
//

import SwiftUI

@_spi(Internal)
public class _ViewPrototypeContext: _HierarchicalViewBridge<_ViewPrototypeContext> {
    
}

@_spi(Internal)
public class _ViewPrototypeRootContext: _ViewPrototypeContext {
    
}

@_spi(Internal)
extension EnvironmentValues {
    public var _viewPrototypeContextBox: Weak<_ViewPrototypeContext>? {
        self[_viewBridgeType: Metatype(_ViewPrototypeContext.self)]
    }
}
