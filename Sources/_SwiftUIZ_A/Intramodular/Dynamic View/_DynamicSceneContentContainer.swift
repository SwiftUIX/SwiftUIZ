//
// Copyright (c) Vatsal Manot
//

import SwiftUI
import SwiftUIX

public struct _DynamicSceneContentContainer<Content: View>: View, _DynamicSceneContentContainerType {
    @StateObject private var graph: _AnyDynamicViewGraph = __unsafe_ViewGraphType.init()
    
    public let content: Content
    
    public init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    
    public var body: some View {
        content
            ._modifier(_SetViewGraphScope())
            .transformEnvironment(\._opaque_ViewGraphContext) { context in
                context?._isInvalidInstance = false
                context?._opaque_dynamicViewGraph = graph
            }
            .background {
                _InvisibleAppViewIndexer()
            }
    }
}


@MainActor
public struct _SetViewGraphScope<C: View>: _ThinViewModifier {
    @State private var scope = _ViewGraphScopeID()
    
    public init() {
        
    }
    
    public func body(content: C) -> some View {
        content.transformEnvironment(\._opaque_ViewGraphContext) { context in
            if let _context = context {
                assert(!_context._isInvalidInstance)
            }
            
            context?.scope = scope
        }
    }
}
