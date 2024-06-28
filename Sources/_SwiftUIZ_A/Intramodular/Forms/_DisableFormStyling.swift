//
// Copyright (c) Vatsal Manot
//

import Swift
import SwiftUIIntrospect
@_spi(Internal) import SwiftUIX

struct _DisableFormStyling: ViewModifier {
    func body(content: Content) -> some View {
        Section {
            EmptyView()
        } header: {
            ZStack {
                HSpacer()
                
                content
            }
        }
    }
}

extension View {
    public func _disableFormStyling() -> some View {
        modifier(_DisableFormStyling())
    }
}

@available(tvOS, unavailable)
@available(watchOS, unavailable)
extension View {
    public func _stripAllListOrListItemStyling() -> some View {
        self.modifier(_StipAllListItemStyling(insetsIncluded: false))
            .listStyle(.plain)
            .scrollContentBackground(.hidden)
    }
}

public struct _StipAllListItemStyling: ViewModifier {
    public let insetsIncluded: Bool
    
    public init(insetsIncluded: Bool) {
        self.insetsIncluded = insetsIncluded
    }
    
    public func body(content: Content) -> some View {
        content
            .listRowSeparator(.hidden)
            .listSectionSeparator(.hidden)
            .listRowInsets(insetsIncluded ? .zero : nil)
            .listItemTint(Optional<Color>.none)
            .listRowBackground(Color.clear)
    }
}
