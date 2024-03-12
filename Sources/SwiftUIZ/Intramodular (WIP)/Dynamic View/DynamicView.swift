//
// Copyright (c) Vatsal Manot
//

import _SwiftUI_Internals
import SwiftUI

public protocol _DynamicViewStyleConfiguration {
    
}

/// This type is **WIP**.
public protocol DynamicView: _DynamicView, _ThinForceModifiedView where ViewModifierType == _DynamicViewModifier<Body> {
    var _unsafeDynamicViewFlags: Set<_UnsafeDynamicViewFlag> { get }
}

// MARK: - Implementation

extension DynamicView {
    public var _unsafeDynamicViewFlags: Set<_UnsafeDynamicViewFlag> {
        []
    }
}

// MARK: - Internal

public protocol _DynamicView: View {
    
}

public enum _UnsafeDynamicViewFlag: Hashable {
    
}

extension _DynamicView {
    public typealias ViewModifierType = _DynamicViewModifier<Body>
}

public struct _DynamicViewModifier<Content: View>: Initiable, _ThinViewModifier {
    public init() {
        
    }
    
    public func body(content: Content) -> some View {
        _ManagedDynamicViewBody(root: content) {
            content
        }
    }
}
