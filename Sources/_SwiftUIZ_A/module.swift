//
// Copyright (c) Vatsal Manot
//

@_exported import Swallow
@_exported import SwallowMacrosClient
@_exported import _SwiftUI_Internals
@_exported import SwiftUIX
@_exported import SwiftUIZ_Macros

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
