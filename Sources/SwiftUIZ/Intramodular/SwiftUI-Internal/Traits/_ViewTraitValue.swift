//
// Copyright (c) Vatsal Manot
//

import Swallow
import SwiftUIX

public protocol _ViewTraitValue {
    associatedtype _ViewTraitKeyType
}

// MARK: - Auxiliary

public struct _ViewTraitsResolutionContext {
    public enum Mode {
        case regular
        case traitOnly
    }
    
    public let mode: Mode
    
    public init(mode: Mode = .regular) {
        self.mode = mode
    }
}

extension EnvironmentValues {
    @EnvironmentValue public var _traitsResolutionContext = _ViewTraitsResolutionContext()
}

/*public struct _DetachablePreferenceTrait<Key: _PreferenceTraitKey, Content: View>: _ThinViewModifier {
    @Environment(\._traitsResolutionContext) var context
    
    public var key: Key.Type
    public var value: Key.Value
    
    public init(
        key: Key.Type,
        value: Key.Value
    ) {
        self.key = key
        self.value = value
    }
    
    public func body(content: Content) -> some View {
        Group {
            if context.viewDisabledTypes.contains(Metatype(key)) {
                ZeroSizeView()
            } else {
                content
            }
        }
        ._preferenceTrait(key, value)
    }
}

public struct _DetachableViewTrait<Key: _ViewTraitKey, Content: View>: _ThinViewModifier {
    @Environment(\._traitsResolutionContext) var context
    
    public var key: Key.Type
    public var value: Key.Value
    
    public init(
        key: Key.Type,
        value: Key.Value
    ) {
        self.key = key
        self.value = value
    }
    
    public func body(content: Content) -> some View {
        Group {
            if context.viewDisabledTypes.contains(Metatype(key)) {
                ZeroSizeView()
            } else {
                content
            }
        }
        ._trait(key, value)
    }
}
*/
