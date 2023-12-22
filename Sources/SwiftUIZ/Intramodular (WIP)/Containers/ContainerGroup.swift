//
// Copyright (c) Vatsal Manot
//

import Diagnostics
@_spi(Internal) import SwiftUIX

public struct ContainerGroup<Content: View>: DynamicView {
    let content: Content
    
    public init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    
    public var body: some View {
        content
    }
}
