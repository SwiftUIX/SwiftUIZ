//
// Copyright (c) Vatsal Manot
//

import SwiftUIX

fileprivate struct _HostViewBridge<Bridge: _HierarchicalViewBridgeType, Content: View>: _ThinViewModifier where Bridge.InstanceType: __HierarchicalViewBridgeType {
    @Environment(\.[_viewBridgeType: Metatype(Bridge.InstanceType.self)]) @Weak private var parentBridge: Bridge.InstanceType?

    @ObservedObject var bridge: Bridge
    
    var _weakBridge: Weak<Bridge.InstanceType> {
        Weak(Optional.some(bridge as! Bridge.InstanceType))
    }
    
    func body(
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

public struct _ViewBridgeTraitKey<Bridge: __HierarchicalViewBridgeType>: _ViewTraitKey {
    public static var defaultValue: Weak<Bridge> {
        Weak(nil)
    }
    
    public init<_Bridge: _HierarchicalViewBridgeType>(
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
    struct _HierarchicalViewBridgeKey<T>: EnvironmentKey {
        typealias Value = Weak<T>
        
        static var defaultValue: Value {
            .init(nil)
        }
    }
    
    subscript<T>(
        _viewBridgeType type: Metatype<T.Type>
    ) -> Weak<T> {
        get {
            self[_HierarchicalViewBridgeKey<T>.self]
        } set {
            self[_HierarchicalViewBridgeKey<T>.self] = newValue
        }
    }
}
