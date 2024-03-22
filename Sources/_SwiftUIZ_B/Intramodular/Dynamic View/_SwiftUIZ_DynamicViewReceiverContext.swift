//
// Copyright (c) Vatsal Manot
//

import SwiftUIX

/// A context donated by a view to describe itself as a *receiver*.
@_spi(Internal)
public struct _SwiftUIZ_DynamicViewReceiverContext: Equatable {
    public var bridge: _DynamicViewBridge
    
    public init(bridge: _DynamicViewBridge) {
        self.bridge = bridge
    }
}

extension _SwiftUIZ_DynamicViewReceiverContext {
    struct _PreferenceKey: SwiftUI.PreferenceKey {
        typealias Value = _SwiftUIZ_DynamicViewReceiverContext?
        
        static func reduce(
            value: inout Value,
            nextValue: () -> Value
        ) {
            value = nextValue() ?? value
        }
    }
}
