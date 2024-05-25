//
// Copyright (c) Vatsal Manot
//

import SwiftUIX

extension WindowGroup: _SceneX where Content: _DynamicSceneContentContainerType {
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
    
    public init<C: View>(
        _: _DynamicWindowGroupKeyword,
        _ content: @escaping @autoclosure () -> C
    ) where Content == _DynamicSceneContentContainer<C> {
        self.init(content: {
            _DynamicSceneContentContainer(content: content)
        })
    }
}
