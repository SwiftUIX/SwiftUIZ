//
// Copyright (c) Vatsal Manot
//

import SwiftUIX

#if os(macOS)
extension Window: _ExtendedScene where Content: _InterposedSceneContent {
    public enum _DynamicWindowGroupKeyword {
        case dynamic
    }
    
    public init<ID: RawRepresentable<String>, C: View>(
        _: _DynamicWindowGroupKeyword,
        title: String,
        id: ID,
        @ViewBuilder content: () -> C
    ) where Content == _InterposeSceneContent<C> {
        self.init(title, id: id.rawValue, content: {
            _InterposeSceneContent(content: content)
        })
    }
    
    public init<ID: RawRepresentable<String>, C: View>(
        _: _DynamicWindowGroupKeyword,
        title: String,
        id: ID,
        _ content: @escaping @autoclosure () -> C
    ) where Content == _InterposeSceneContent<C> {
        self.init(title, id: id.rawValue, content: {
            _InterposeSceneContent(content: content)
        })
    }
}
#endif

extension WindowGroup: _ExtendedScene where Content: _InterposedSceneContent {
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
    
    public init<ID: RawRepresentable<String>, C: View>(
        _: _DynamicWindowGroupKeyword,
        id: ID,
        @ViewBuilder content: () -> C
    ) where Content == _InterposeSceneContent<C> {
        self.init(id: id.rawValue, content: {
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
