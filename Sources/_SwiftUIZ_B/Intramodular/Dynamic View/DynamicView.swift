//
// Copyright (c) Vatsal Manot
//

import _SwiftUI_Internals
import SwallowMacrosClient
import SwiftUI

public protocol _DynamicViewStyleConfiguration {
    
}

/// This type is **WIP**.
public protocol DynamicView: _DynamicView, _ThinForceModifiedView where ViewModifierType == _DynamicViewModifier<Self, Body> {
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
    public typealias ViewModifierType = _DynamicViewModifier<Self, Body>
}

public struct _DynamicViewModifier<Root: View, Content: View>: Initiable, _ThinForceViewModifier {
    public init() {
        SwallowMacrosClient.module.initialize()
    }
    
    @ViewBuilder
    public func body(root: Root, content: LazyView<Content>) -> some View {
        _ManagedDynamicViewBody(root: root) {
            content
        }
    }
}
