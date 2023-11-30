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
    
    public init(root: Root, @ViewBuilder content: () -> Content) {
        self.root = root
        self.content = content()
    }
    
    @usableFromInline
    @ViewStorage var descriptor: _SwiftUIZ_ViewDescriptor?
    
    @_transparent
    public var body: some View {
        let _ = _expectNoThrow {
            try _initializeViewDescriptor()
        }
        
        content
            ._trait(_SwiftUIZ_ParameterReceiverContext.self, .init(descriptor: descriptor!))
    }
    
    @usableFromInline
    func _initializeViewDescriptor() throws {
        guard descriptor == nil else {
            return
        }
        
        descriptor = try .init(from: root)
    }
}
