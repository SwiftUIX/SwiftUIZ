//
// Copyright (c) Vatsal Manot
//

import SwiftUI

public protocol _DynamicView: View {
    
}

extension _DynamicView {
    public typealias ViewModifierType = _DynamicViewModifier<Self>
}

/// This type is **WIP**.
public protocol DynamicView: _DynamicView, _ThinForceModifiedView where ViewModifierType == _DynamicViewModifier<Self> {
    
}

// MARK: - Internal

public struct _DynamicViewModifier<Content: View>: Initiable, _ThinViewModifier {
    public init() {
        
    }
    
    public func body(content: Content) -> some View {
        content
    }
}

struct Foo: DynamicView {
    var body: some View {
        Text("")
    }
}
