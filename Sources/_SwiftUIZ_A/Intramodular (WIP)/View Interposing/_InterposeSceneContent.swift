//
// Copyright (c) Vatsal Manot
//

import Swallow
import SwiftUI
import SwiftUIX

public struct _InterposeSceneContent<Content: View>: View, _InterposedSceneContent {
    @StateObject private var graph: _AnyViewHypergraph = __unsafe_ViewGraphType.init()
    
    public let content: Content
    
    var _invisibleAppViewIndexingDisabled: Bool = false
    
    public init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    
    public init(_ content: Content) {
        self.content = content
    }
    
    public func _disableInvisibleAppViewIndexing() -> Self {
        withMutableScope(self) {
            $0._invisibleAppViewIndexingDisabled = true
        }
    }
    
    public var body: some View {
        content
            ._modifier(_SetViewInterposeScope())
            .transformEnvironment(\._opaque_interposeContext) { context in
                context?._isInvalidInstance = false
                context?._opaque_dynamicViewGraph = graph
            }
            .background {
                if !_invisibleAppViewIndexingDisabled {
                    _InvisibleAppViewIndexer()
                        .transformEnvironment(\._opaque_interposeContext) { context in
                            context?._isInvalidInstance = false
                            context?._opaque_dynamicViewGraph = graph
                        }
                }
            }
    }
}


