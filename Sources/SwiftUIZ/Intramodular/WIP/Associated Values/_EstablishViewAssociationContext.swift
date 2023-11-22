//
// Copyright (c) Vatsal Manot
//

import Swallow

public struct ViewAssociationLevelProxy {
    let context: _ViewAssociationContext
}

public struct ViewAssociationLevel<Content: View>: View {
    public let content: (ViewAssociationLevelProxy) -> Content
    
    let modifier = _EstablishViewAssociationContext<Content>()
    
    public init(@ViewBuilder content: @escaping (ViewAssociationLevelProxy) -> Content) {
        self.content = content
    }
    
    public var body: some View {
        content(.init(context: modifier.context))
            ._modifier(modifier)
    }
}
struct _EstablishViewAssociationContext<Content: View>: _ThinViewModifier {
    @Environment(\._viewAssociationContext) @Weak private var _parentContext
    
    @StateObject var context = _ViewAssociationContext()
        
    public func body(content: Content) -> some View {
        content
            ._onAvailability(of: _parentContext) { _parentContext in
                context.adopt(_parentContext)
            }
    }
}

