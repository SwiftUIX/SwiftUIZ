//
// Copyright (c) Vatsal Manot
//

import SwiftUIX

@_spi(Internal)
public struct _DynamicViewReceptor: Equatable {
    public var bridge: _DynamicViewElementBridge
    
    public init(bridge: _DynamicViewElementBridge) {
        self.bridge = bridge
    }
}

extension _DynamicViewReceptor {
    struct _PreferenceKey: SwiftUI.PreferenceKey {
        typealias Value = _DynamicViewReceptor?
        
        static func reduce(
            value: inout Value,
            nextValue: () -> Value
        ) {
            value = nextValue() ?? value
        }
    }
}
