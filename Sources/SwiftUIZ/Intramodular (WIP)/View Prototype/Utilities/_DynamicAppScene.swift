//
// Copyright (c) Vatsal Manot
//

import SwiftUI

public protocol _DynamicAppScene: Scene {
    
}

// MARK: - Implemented Conformances

extension DiscoveredScenes: _DynamicAppScene {
    
}

extension WindowGroup: _DynamicAppScene where Content: _DVCanvasType {
    public enum _DynamicWindowGroupKeyword {
        case dynamic
    }
    
    public init<C: View>(
        _: _DynamicWindowGroupKeyword,
        @ViewBuilder content: () -> C
    ) where Content == _DVCanvas<C> {
        self.init(content: {
            _DVCanvas(content: content)
        })
    }
}
