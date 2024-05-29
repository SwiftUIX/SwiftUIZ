//
// Copyright (c) Vatsal Manot
//

import SwiftUIX

extension WindowGroup: _SceneX where Content: _InterposedSceneContent {
    public enum _DynamicWindowGroupKeyword {
        case dynamic
    }
    
    public init<C: View>(
        _: _DynamicWindowGroupKeyword,
        @ViewBuilder content: () -> C
    ) where Content == _InterposeSceneContent<C> {
        self.init(content: {
            _InterposeSceneContent(content: content)
        })
    }
    
    public init<C: View>(
        _: _DynamicWindowGroupKeyword,
        _ content: @escaping @autoclosure () -> C
    ) where Content == _InterposeSceneContent<C> {
        self.init(content: {
            _InterposeSceneContent(content: content)
        })
    }
}
