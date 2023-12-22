//
// Copyright (c) Vatsal Manot
//

import Diagnostics
@_spi(Internal) import SwiftUIX

public enum _DynamicViewContentUnsafeFlag: Hashable {
    
}

@_spi(Internal)
@frozen
public struct _DynamicViewContent<Root: View, Content: View>: View {
    @usableFromInline
    let root: Root
    @usableFromInline
    let content: Content
    
    public init(
        root: Root,
        @ViewBuilder content: () -> Content
    ) {
        self.root = root
        self.content = content()
    }
    
    @StateObject var bridge = _DynamicViewElementBridge()
        
    public var body: some View {
        let _: Void = _initializeViewDescriptor()

        content
            .trait(_DynamicViewReceptor.self, _DynamicViewReceptor(bridge: bridge))
            ._host(bridge)
    }
    
    @usableFromInline
    func _initializeViewDescriptor() {
        _expectNoThrow {
            guard bridge.descriptor == nil else {
                return
            }
            
            bridge.descriptor = try .init(from: root)
        }
    }
}
