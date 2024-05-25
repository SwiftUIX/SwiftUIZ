//
// Copyright (c) Vatsal Manot
//

import SwiftUIX

extension _DynamicViewProxy {
    /// A context donated by a view to describe itself as a *receiver*.
    @_spi(Internal)
    public struct HydrationSurface: Equatable {
        public var bridge: _DynamicViewBridge
        
        public init?(bridge: _DynamicViewBridge) {
            self.bridge = bridge
        }
    }
}

extension _DynamicViewProxy.HydrationSurface {
    struct _PreferenceKey: SwiftUI.PreferenceKey {
        typealias Value = _DynamicViewProxy.HydrationSurface?
        
        static func reduce(
            value: inout Value,
            nextValue: () -> Value
        ) {
            value = nextValue() ?? value
        }
    }
}
