//
// Copyright (c) Vatsal Manot
//

import Swallow
import SwiftUIX

public protocol _ViewTraitValue {
    associatedtype _ViewTraitKeyType: _ViewTraitKey
}

public struct _ViewTraitValuesResolutionContext {
    public var viewDisabledTypes: Set<Metatype<Any.Type>> = []
    
    public init() {
        
    }
}

extension EnvironmentValues {
    @EnvironmentValue var _traitValuesResolutionContext = _ViewTraitValuesResolutionContext()
}

public struct _DetachableViewTrait<Key: _ViewTraitKey>: ViewModifier {
    @Environment(\._traitValuesResolutionContext) var context
    
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
                    ._trait(key, value)
            } else {
                content
                    ._trait(key, value)
            }
        }
    }
}
