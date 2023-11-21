//
// Copyright (c) Vatsal Manot
//

import SwiftUI

public protocol _SwiftUIX_ViewTraitKey<Value>: Hashable, Sendable {
    associatedtype Value
    associatedtype ValueBox: _SwiftUIX_AnyMutableValueBox<Value> = _SwiftUIX_MutableValueBox<Value> where ValueBox.Value == Value
    
    static var defaultValue: Value { get }
}

@available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
extension View {
    public func trait<Value>(
        _ value: Value
    ) -> some View {
        trait(_ViewTraitKeyFromType<Value>(), value)
    }
    
    public func trait<Key: _SwiftUIX_ViewTraitKey>(
        _ key: Key,
        _ value: Key.Value
    ) -> some View {
        self.transformEnvironment(\._SwiftUIX_viewTraitValues) { traits in
            traits[key] = value
        }
        ._transformViewTraitValues {
            $0[key] = value
        }
        ._trait(
            _SwiftUIX_ViewTraitKeyAdaptor<Key>.self,
            .init(wrappedValue: value)
        )
    }
    
    public func _transformViewTraitValues(
        _ transform: @escaping (inout _SwiftUIX_ViewTraitValues) -> Void
    ) -> some View {
        modifier(_SwiftUIX_TransformViewTraitValues(transform: transform))
    }
}

extension View {
    public func _WIP_trait<Value>(
        _ key: WritableKeyPath<_SwiftUIX_ViewTraitValues, Value>,
        _ value: Value
    ) -> some View {
        self.transformEnvironment(\._SwiftUIX_viewTraitValues) { traits in
            traits[keyPath: key] = value
        }
        ._transformViewTraitValues {
            $0[keyPath: key] = value
        }
    }
}

@available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
fileprivate struct _SwiftUIX_TransformViewTraitValues: ViewModifier {
    let transform: (inout _SwiftUIX_ViewTraitValues) -> Void
    
    func body(content: Content) -> some View {
        _VariadicViewAdapter(content) { content in
            _ForEachSubview(content) { subview in
                transformSubview(subview)
            }
        }
    }
    
    private func transformSubview(
        _ subview: _VariadicViewChildren.Subview
    ) -> some View {
        var subview = subview
        var traits = subview[trait: \._SwiftUIX_viewTraitValues]
        
        transform(&traits)
        
        subview[trait: \._SwiftUIX_viewTraitValues] = traits
        
        return subview._trait(\._SwiftUIX_viewTraitValues, traits)
    }
}

// MARK: - Auxiliary

@available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
extension _SwiftUIX_ViewTraitValues {
    fileprivate struct _EnvironmentKey: EnvironmentKey {
        static let defaultValue = _SwiftUIX_ViewTraitValues()
    }
    
    public struct _ViewTraitKey: SwiftUI._ViewTraitKey {
        public static let defaultValue = _SwiftUIX_ViewTraitValues()
    }
}

@available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
extension _ViewTraitKeys {
    @_spi(Internal)
    public var _SwiftUIX_viewTraitValues: _SwiftUIX_ViewTraitValues._ViewTraitKey.Type {
        _SwiftUIX_ViewTraitValues._ViewTraitKey.self
    }
}

@available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
extension EnvironmentValues {
    @_spi(Internal)
    public var _SwiftUIX_viewTraitValues: _SwiftUIX_ViewTraitValues {
        get {
            self[_SwiftUIX_ViewTraitValues._EnvironmentKey.self]
        } set {
            self[_SwiftUIX_ViewTraitValues._EnvironmentKey.self] = newValue
        }
    }
}
