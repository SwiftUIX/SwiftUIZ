//
// Copyright (c) Vatsal Manot
//

import Diagnostics
import Runtime
@_spi(Internal) import SwiftUIX

@MainActor
public struct _InterposedViewBodyProxy: DynamicProperty {
    weak var _viewBridge: _InterposedViewBodyBridge?
    weak var _storage: _InterposedViewBodyStorage?
    
    var storage: _InterposedViewBodyStorage {
        get throws {
            try _storage.unwrap()
        }
    }
    
    package var root: any View
    package var content: any View
    
    let graphContext: EnvironmentValues._InterposeGraphContext
    
    init(
        _viewBridge: _InterposedViewBodyBridge,
        _storage: _InterposedViewBodyStorage?,
        root: any View,
        content: any View,
        graphContext: EnvironmentValues._InterposeGraphContext
    ) {
        self._viewBridge = _viewBridge
        self._storage = _storage
        self.root = root
        self.content = content
        self.graphContext = graphContext
    }
}
