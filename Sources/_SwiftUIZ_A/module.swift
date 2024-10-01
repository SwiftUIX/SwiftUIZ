//
// Copyright (c) Vatsal Manot
//

@_exported import Swallow
@_exported import SwallowMacrosClient
@_exported import _SwiftUI_Internals
@_exported import SwiftUIX

// MARK: - Other

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

public var __unsafe_ViewGraphType: _AnyViewHypergraph.Type?

public var __unsafe_EnvironmentValues_opaque_interposeContext_getter: (EnvironmentValues) -> (any EnvironmentValues._opaque_InterposeGraphContextProtocol)? = { _ in
    nil
}

public var __unsafe_EnvironmentValues_opaque_interposeContext_setter: (inout EnvironmentValues, (any EnvironmentValues._opaque_InterposeGraphContextProtocol)?) -> Void = { _, _ in
    fatalError()
}

#once {
    __unsafe_EnvironmentValues_opaque_interposeContext_getter = { environment in
        environment._interposeContext
    }
    __unsafe_EnvironmentValues_opaque_interposeContext_setter = { (environment: inout EnvironmentValues, newValue: (any EnvironmentValues._opaque_InterposeGraphContextProtocol)?) in
        if let context: EnvironmentValues._InterposeGraphContext = newValue.flatMap({ $0 as? EnvironmentValues._InterposeGraphContext }) {
            environment._interposeContext = context
        } else {
            runtimeIssue("Failed to initialize an interpose context.")
        }
    }
    
    if let type = NSClassFromString("_SwiftUIZ_type_Ferrofluid.ViewHypergraph") as? _AnyViewHypergraph.Type {
        __unsafe_ViewGraphType = type
    } else if let type = NSClassFromString("_SwiftUIZ_type_LightweightViewHypergraph") as? _AnyViewHypergraph.Type {
        __unsafe_ViewGraphType = type.self
    } else {
        runtimeIssue("Failed to resolve `__unsafe_ViewGraphType`.")
    }
}
