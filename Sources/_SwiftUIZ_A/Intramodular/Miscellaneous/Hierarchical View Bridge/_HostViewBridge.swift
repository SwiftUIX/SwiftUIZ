//
// Copyright (c) Vatsal Manot
//

import SwiftUIX

package struct _HostViewBridge<Bridge: _HierarchicalViewBridgeType, Content: View>: _ThinViewModifier where Bridge.InstanceType: __HierarchicalViewBridgeType {
    @Environment(\.[_viewBridgeType: Metatype(Bridge.InstanceType.self)]) @Weak private var parentBridge: Bridge.InstanceType?

    @ObservedObject var bridge: Bridge
    
    package var _weakBridge: Weak<Bridge.InstanceType> {
        Weak(Optional.some(bridge as! Bridge.InstanceType))
    }
    
    package func body(
        content: Content
    ) -> some View {
        content
            .environment(\.[_viewBridgeType: Metatype(Bridge.InstanceType.self)], _weakBridge)
            ._trait(_ViewBridgeTraitKey<Bridge.InstanceType>.self, _weakBridge)
            ._onAvailability(of: parentBridge) { parentBridge in
                (parentBridge as! (any _HierarchicalViewBridgeType))._opaque_add(bridge)
            }
    }
}

package struct _ViewBridgeTraitKey<Bridge: __HierarchicalViewBridgeType>: _ViewTraitKey {
    package static var defaultValue: Weak<Bridge> {
        Weak(nil)
    }
    
    package init<_Bridge: _HierarchicalViewBridgeType>(
        _ bridgeType: _Bridge.Type
    ) where Bridge == _Bridge.InstanceType {
        
    }
}

// MARK: - Supplementary

extension View {
    /// Host the given view bridge.
    public func _host<T: _HierarchicalViewBridgeType>(
        _ bridge: T
    ) -> some View where T.InstanceType: __HierarchicalViewBridgeType {
        _modifier(_HostViewBridge(bridge: bridge))
    }
}

// MARK: - Auxiliary

extension EnvironmentValues {
    package struct _HierarchicalViewBridgeKey<T>: EnvironmentKey {
        package typealias Value = Weak<T>
        
        package static var defaultValue: Value {
            .init(nil)
        }
    }
    
    package subscript<T>(
        _viewBridgeType type: Metatype<T.Type>
    ) -> Weak<T> {
        get {
            self[_HierarchicalViewBridgeKey<T>.self]
        } set {
            self[_HierarchicalViewBridgeKey<T>.self] = newValue
        }
    }
}
