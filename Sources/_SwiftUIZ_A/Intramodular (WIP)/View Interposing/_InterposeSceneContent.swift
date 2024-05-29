//
// Copyright (c) Vatsal Manot
//

import SwiftUI
import SwiftUIX

public struct _InterposeSceneContent<Content: View>: View, _InterposedSceneContent {
    @StateObject private var graph: _AnyDynamicViewGraph = __unsafe_ViewGraphType.init()
    
    public let content: Content
    
    public init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    
    public var body: some View {
        content
            ._modifier(_SetViewInterposeScope())
            .transformEnvironment(\._opaque_interposeContext) { context in
                context?._isInvalidInstance = false
                context?._opaque_dynamicViewGraph = graph
            }
            .background {
                _InvisibleAppViewIndexer()
            }
    }
}


