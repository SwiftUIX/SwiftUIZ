//
// Copyright (c) Vatsal Manot
//

import _SwiftUI_Internals
@_spi(Internal) import SwiftUIX

public struct _InterposeViewBody<Root: DynamicView, Content: View>: Initiable, _ThinForceViewModifier {
    public init() {
        
    }
    
    @ViewBuilder
    public func body(
        root: Root,
        content: LazyView<Content>
    ) -> some View {
        _InterposedViewBody(root: root) {
            content
        }
        .environment(\._lazyViewResolver, _AnyLazyViewResolver(resolve: { resolve in
            let context: _TaskLocalValues._DynamicViewGraph = withMutableScope(_TaskLocalValues._dynamicViewGraph) {
                $0._managedDynamicViewBodyModifier = .init(root: type(of: root), content: Content.self)
            }
            
            return _TaskLocalValues.$_dynamicViewGraph.withValue(context) {
                resolve()
            }
        }))
    }
}
