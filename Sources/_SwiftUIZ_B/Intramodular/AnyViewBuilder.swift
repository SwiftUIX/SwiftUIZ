//
// Copyright (c) Vatsal Manot
//

import SwiftUI

@resultBuilder
public struct AnyViewBuilder {
    @_transparent
    public static func buildBlock<T: View>(
        _ component: T
    ) -> AnyView {
        component.eraseToAnyView()
    }
    
    @_transparent
    public static func buildBlock<each Content>(
        _ content: repeat each Content
    ) -> AnyView {
        TupleView((repeat each content)).eraseToAnyView()
    }
    
    @_transparent
    public static func buildPartialBlock<T: View>(
        _ component: T
    ) -> AnyView {
        component.eraseToAnyView()
    }
    
    @_transparent
    public static func buildPartialBlock<each Content>(
        _ content: repeat each Content
    ) -> AnyView where repeat each Content: View {
        buildBlock(repeat each content)
    }
}
