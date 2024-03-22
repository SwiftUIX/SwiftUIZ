//
// Copyright (c) Vatsal Manot
//

import SwiftUI

public protocol _DynamicAppScene: _SwiftUIZ_MaybePrimitiveScene {
    
}

// MARK: - Implemented Conformances

extension WindowGroup: _DynamicAppScene where Content: _DynamicSceneContentContainerType {
    public enum _DynamicWindowGroupKeyword {
        case dynamic
    }
    
    public init<C: View>(
        _: _DynamicWindowGroupKeyword,
        @ViewBuilder content: () -> C
    ) where Content == _DynamicSceneContentContainer<C> {
        self.init(content: {
            _DynamicSceneContentContainer(content: content)
        })
    }
}
