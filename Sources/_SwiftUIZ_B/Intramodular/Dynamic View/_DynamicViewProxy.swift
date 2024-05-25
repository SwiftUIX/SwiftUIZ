//
// Copyright (c) Vatsal Manot
//

import Diagnostics
import Runtime
@_spi(Internal) import SwiftUIX

@MainActor
public struct _DynamicViewProxy: DynamicProperty {
    weak var _dynamicViewBridge: _DynamicViewBridge?
    weak var _storage: _DynamicViewBodyStorage?
    
    var storage: _DynamicViewBodyStorage {
        get throws {
            try _storage.unwrap()
        }
    }
    
    package var root: any View
    package var content: any View
    
    let _dynamicViewGraphContext: _DynamicViewGraphContext
    
    init(
        _dynamicViewBridge: _DynamicViewBridge,
        _storage: _DynamicViewBodyStorage?,
        root: any View,
        content: any View,
        graphContext: _DynamicViewGraphContext
    ) {
        self._dynamicViewBridge = _dynamicViewBridge
        self._storage = _storage
        self.root = root
        self.content = content
        self._dynamicViewGraphContext = graphContext
    }
}
