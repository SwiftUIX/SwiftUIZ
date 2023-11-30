//
// Copyright (c) Vatsal Manot
//

import SwiftUI

// MARK: - Implementation

/// This type is **WIP**.
public protocol DynamicView: _DynamicView, _ThinForceModifiedView where ViewModifierType == _DynamicViewModifier<Self> {
    var _unsafeDynamicViewFlags: Set<_DynamicViewContentUnsafeFlag> { get }
}

// MARK: - Implementation

extension DynamicView {
    public var _unsafeDynamicViewFlags: Set<_DynamicViewContentUnsafeFlag> {
        []
    }
}

// MARK: - Internal

public protocol _DynamicView: View {
    
}

extension _DynamicView {
    public typealias ViewModifierType = _DynamicViewModifier<Self>
}

public struct _DynamicViewModifier<Content: View>: Initiable, _ThinViewModifier {
    public init() {
        
    }
    
    public func body(content: Content) -> some View {
        _DynamicViewContent(root: content) {
            content
        }
    }
}
