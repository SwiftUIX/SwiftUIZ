//
// Copyright (c) Vatsal Manot
//

@_exported import Expansions
@_exported import Swallow
@_exported import SwiftUIX

@attached(peer, names: suffixed(_ViewTraitKey))
@attached(extension, names: arbitrary)
public macro _ViewTrait() = #externalMacro(module: "SwiftUIZ_Macros", type: "_ViewTraitValueMacro")

@attached(member, names: arbitrary)
public macro _ViewTraitKey<T>(for: T.Type, named: String) = #externalMacro(module: "SwiftUIZ_Macros", type: "_ViewTraitKeyMacro")

@attached(peer, names: suffixed(_ViewTraitKey))
@attached(extension, names: arbitrary)
public macro _ViewTrait(_: String) = #externalMacro(module: "SwiftUIZ_Macros", type: "_ViewTraitValueMacro")

@attached(peer, names: prefixed(EnvironmentKey_))
@attached(accessor, names: named(get), named(set))
public macro EnvironmentValue() = #externalMacro(module: "SwiftUIZ_Macros", type: "EnvironmentValueMacro")

@attached(memberAttribute)
public macro EnvironmentValuesMacro() = #externalMacro(module: "SwiftUIZ_Macros", type: "EnvironmentValuesMacro")

// MARK: - Other

/// Credits:
/// - https://github.com/Wouter01/SwiftUI-Macros/tree/main

import Swallow

extension ForEach where Content: View {
    public init<Element>(
        _ data: IdentifierIndexingArray<Element, ID>,
        @ViewBuilder content: @escaping (Element) -> Content
    ) where Data == LazyMapSequence<IdentifierIndexingArray<Element, ID>, _ArbitrarilyIdentifiedValue<Element, ID>> {
        let id = data.id
        
        self.init(data.lazy.map({ _ArbitrarilyIdentifiedValue(value: $0, id: id) })) {
            content($0.value)
        }
    }
}
