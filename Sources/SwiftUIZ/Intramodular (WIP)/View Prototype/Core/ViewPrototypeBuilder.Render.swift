//
// Copyright (c) Vatsal Manot
//

import SwiftUIX

extension ViewPrototypeBuilder {
    public struct RenderView<Content: View>: ViewPrototype {
        public let content: Content
        
        public init(content: Content) {
            self.content = content
        }
        
        public init(@ViewBuilder content: () -> Content) {
            self.content = content()
        }
        
        public var body: some View {
            _PushViewPrototypeExpression(
                _UnresolvedViewPrototype(_PrimitiveViewPrototypes.RenderView(content: content))
            )
        }
    }
}

extension ViewPrototype {
    public typealias RenderView<Content: View> = ViewPrototypeBuilder.RenderView<Content>
}
