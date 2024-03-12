//
// Copyright (c) Vatsal Manot
//

import _SwiftUI_Internals
import Swallow

public protocol ViewPrototype: _ForceModifiedView<_ViewPrototypeModifier> {
    @ViewBuilder
    var body: Body { get }
}

public struct _ViewPrototypeModifier: Initiable, ViewModifier {
    public init() {
        
    }
    
    public func body(content: Content) -> some View {
        content
    }
}
