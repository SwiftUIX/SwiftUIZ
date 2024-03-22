//
// Copyright (c) Vatsal Manot
//

import Swallow

public struct _ViewRenderBridgeProxy {
    
}

public struct _ViewLevel<Content: View>: View {
    public let content: (_ViewRenderBridgeProxy) -> Content
        
    public init(@ViewBuilder content: @escaping (_ViewRenderBridgeProxy) -> Content) {
        self.content = content
    }
    
    public var body: some View {
        content(.init())
    }
}

