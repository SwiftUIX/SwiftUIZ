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

public var __unsafe_ViewGraphType: _AnyDynamicViewGraph.Type!

public var __unsafe_EnvironmentValues_opaque_interposeContext_getter: (EnvironmentValues) -> (any EnvironmentValues._opaque_InterposeContextProtocol)? = { _ in
    nil
}

public var __unsafe_EnvironmentValues_opaque_interposeContext_setter: (inout EnvironmentValues, (any EnvironmentValues._opaque_InterposeContextProtocol)?) -> Void = { _, _ in
    fatalError()
}

#once {
    __unsafe_EnvironmentValues_opaque_interposeContext_getter = { environment in
        environment._interposeContext
    }
    __unsafe_EnvironmentValues_opaque_interposeContext_setter = { (environment: inout EnvironmentValues, newValue: (any EnvironmentValues._opaque_InterposeContextProtocol)?) in
        let context: EnvironmentValues._InterposeContext = newValue.map({ $0 as! EnvironmentValues._InterposeContext })!
        
        environment._interposeContext = context
    }
    
    if let type = NSClassFromString("_SwiftUIZ_type_DynamicViewGraph") as? _AnyDynamicViewGraph.Type {
        __unsafe_ViewGraphType = type
    } else if let type = NSClassFromString("_SwiftUIZ_type_DynamicViewGraphLite") as? _AnyDynamicViewGraph.Type {
        __unsafe_ViewGraphType = type.self
    } else {
        runtimeIssue("Failed to resolve `__unsafe_ViewGraphType`.")
    }
}
