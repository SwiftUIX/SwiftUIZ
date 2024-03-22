//
// Copyright (c) Vatsal Manot
//

@_spi(Internal) import SwiftUIX

/// SwiftUIX's version of `_ViewTraitKey`.
///
/// The benefit of using this version is that it allows for dynamic enumeration/manipulation of trait values.
public protocol _SwiftUIX_ViewTraitKey<Value>: Hashable, Sendable {
    associatedtype Value
    associatedtype ValueBox: _SwiftUIX_AnyMutableValueBox<Value> = _SwiftUIX_MutableValueBox<Value> where ValueBox.Value == Value
    
    static var defaultValue: Value { get }
}

public struct _ViewTraitsResolutionContext {
    public enum Mode {
        case regular
        case traitOnly
    }
    
    public let mode: Mode
    
    /// The views holding these traits will be forced to resolve to an `EmptyView`.
    public var disabledTraits: Set<_SwiftUIX_Metatype<any _SwiftUIX_ViewTraitKey.Type>> = []
    
    public init(mode: Mode = .regular) {
        self.mode = mode
    }
}

extension EnvironmentValues {
    @EnvironmentValue var _traitsResolutionContext = _ViewTraitsResolutionContext()
}

private struct _AddViewTrait<Key: _SwiftUIX_ViewTraitKey, Content: View>: _ThinViewModifier {
    @Environment(\._traitsResolutionContext) var traitResolutionContext
    
    let key: Key
    let value: Key.Value
    
    func body(content: Content) -> some View {
        if traitResolutionContext.disabledTraits.contains(.init(type(of: key))) {
            EmptyView()
        } else if traitResolutionContext.mode == .traitOnly {
            _traitOnlyView(content: content)
        } else {
            _contentWithTrait(content: content)
        }
    }
    
    private func _traitOnlyView(content: Content) -> some View {
        _VariadicViewAdapter(content) { content in
            let _: Void = assert(content.children.count == 1)
            
            var traits = content.children.first?.traits._SwiftUIX_viewTraitValues ?? _SwiftUIX_ViewTraitValues()
            
            let _: Void = traits[key] = value
            
            ZeroSizeView()
                ._trait(\._SwiftUIX_viewTraitValues, traits)
        }
    }
    
    private func _contentWithTrait(content: Content) -> some View {
        content
            .transformEnvironment(\._SwiftUIX_viewTraitValues) { traits in
                traits[key] = value
            }
            ._transformTraits {
                $0[key] = value
            }
            ._trait(
                _SwiftUIX_ViewTraitKeys._ToSwiftUIViewTraitKeyAdaptor<Key>.self,
                .init(wrappedValue: value)
            )
    }
}

extension View {
    public func _disableViewsHoldingTrait(key: any _SwiftUIX_ViewTraitKey.Type) -> some View {
        transformEnvironment(\._traitsResolutionContext) {
            $0.disabledTraits.insert(.init(key))
        }
    }
    
    public func _disableViewsHoldingTrait<T>(ofType type: T.Type) -> some View {
        transformEnvironment(\._traitsResolutionContext) {
            $0.disabledTraits.insert(.init(_SwiftUIX_ViewTraitKeys._MetatypeToViewTraitKeyAdaptor<T>.self))
        }
    }
}

@available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
extension View {
    public func trait<Value>(
        _ value: Value
    ) -> some View {
        assert(type(of: value) == Value.self)
        
        return self
            .trait(_SwiftUIX_ViewTraitKeys._MetatypeToViewTraitKeyAdaptor<Value>(), value)
            ._trait(_TypeToViewTraitKeyAdaptor<Value>.self, value)
    }
    
    public func trait<Key: _SwiftUIX_ViewTraitKey>(
        _ key: Key,
        _ value: Key.Value
    ) -> some View {
        _modifier(_AddViewTrait(key: key, value: value))
    }
    
    public func _transformTraits(
        _ transform: @escaping (inout _SwiftUIX_ViewTraitValues) -> Void
    ) -> some View {
        _modifier(_SwiftUIX_TransformTraits(transform: transform))
    }
}

@available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
fileprivate struct _SwiftUIX_TransformTraits<Content: View>: _ThinViewModifier {
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
