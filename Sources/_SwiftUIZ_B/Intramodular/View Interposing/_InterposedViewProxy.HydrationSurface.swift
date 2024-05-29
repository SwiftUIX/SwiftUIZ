//
// Copyright (c) Vatsal Manot
//

import SwiftUIX

extension _InterposedViewBodyProxy {
    /// A context donated by a view to describe itself as a *receiver*.
    @_spi(Internal)
    public struct HydrationSurface: Equatable {
        public var bridge: _InterposedViewBodyBridge
        
        public init?(bridge: _InterposedViewBodyBridge) {
            self.bridge = bridge
        }
    }
}

extension _InterposedViewBodyProxy.HydrationSurface {
    struct _PreferenceKey: SwiftUI.PreferenceKey {
        typealias Value = _InterposedViewBodyProxy.HydrationSurface?
        
        static func reduce(
            value: inout Value,
            nextValue: () -> Value
        ) {
            value = nextValue() ?? value
        }
    }
}

extension _InterposedViewBodyBridge: _ShallowEnvironmentHydrationSurface {
    public var staticViewTypeDescriptor: _StaticViewTypeDescriptor {
        bodyStorage.dynamicViewGraphInsertion.node.staticViewTypeDescriptor
    }
}
