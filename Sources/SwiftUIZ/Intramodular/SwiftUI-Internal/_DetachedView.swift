//
// Copyright (c) Vatsal Manot
//

import SwiftUIX

/// A view that is detached (i.e. not rendered) but can still be used to read traits.
public struct _DetachedView<Content: View>: View {
    let content: Content
    let inspect: (DetatchedViewProxy<Content>) -> Void
    
    public init(
        _ content: Content,
        inspect: @escaping (DetatchedViewProxy<Content>) -> Void
    ) {
        self.content = content
        self.inspect = inspect
    }
    
    public var body: some View {
        _VariadicViewAdapter(content) { children in
            PerformAction(deferred: false) {
                inspect(.init(base: children))
            }
        }
    }
}

public struct DetatchedViewProxy<Content: View> {
    let base: _TypedVariadicView<Content>
}
