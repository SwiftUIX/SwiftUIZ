//
// Copyright (c) Vatsal Manot
//

import SwiftUI

@frozen
public struct _SwiftUI_UnaryViewAdaptor<Content: View>: View {
    @usableFromInline
    var content: Content
    
    @inlinable
    public init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    
    public var body: some View {
        _UnaryViewAdaptor(content)
    }
}
