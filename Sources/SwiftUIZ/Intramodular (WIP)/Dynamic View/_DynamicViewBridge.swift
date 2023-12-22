//
// Copyright (c) Vatsal Manot
//

import SwiftUIX

@_spi(Internal)
public class _DynamicViewBridge: _HierarchicalViewBridge<_DynamicViewBridge> {
    
}

@_spi(Internal)
public class _DynamicViewSceneBridge: _DynamicViewBridge {
    
}

@_spi(Internal)
public class _DynamicViewElementBridge: _DynamicViewBridge {
    public var descriptor: _DynamicViewDescriptor!
}
