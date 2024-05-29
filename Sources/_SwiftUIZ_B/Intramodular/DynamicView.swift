//
// Copyright (c) Vatsal Manot
//

import _SwiftUI_Internals
import SwiftUIX

/// This type is **WIP**.
public protocol DynamicView: _DynamicView, _ThinForceModifiedView where ViewModifierType == _InterposeViewBody<Self, Body> {
    var _unsafeDynamicViewFlags: Set<_UnsafeDynamicViewFlag> { get }
}

// MARK: - Implementation

extension DynamicView {
    public var _unsafeDynamicViewFlags: Set<_UnsafeDynamicViewFlag> {
        []
    }
}

// MARK: - Internal

public enum _UnsafeDynamicViewFlag: Hashable {
    
}

extension _DynamicView where Self: DynamicView {
    public typealias ViewModifierType = _InterposeViewBody<Self, Body>
}

