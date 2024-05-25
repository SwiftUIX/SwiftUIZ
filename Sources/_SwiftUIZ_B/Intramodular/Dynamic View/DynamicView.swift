//
// Copyright (c) Vatsal Manot
//

import _SwiftUI_Internals
import SwallowMacrosClient
@_spi(Internal) import SwiftUIX

/// This type is **WIP**.
public protocol DynamicView: _DynamicView, _ThinForceModifiedView where ViewModifierType == _DynamicViewBodyModifier<Self, Body> {
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
    public typealias ViewModifierType = _DynamicViewBodyModifier<Self, Body>
}

public struct _DynamicViewBodyModifier<Root: DynamicView, Content: View>: Initiable, _ThinForceViewModifier {
    public init() {
        
    }
    
    @ViewBuilder
    public func body(
        root: Root,
        content: LazyView<Content>
    ) -> some View {
        _DynamicViewBody(root: root) {
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
