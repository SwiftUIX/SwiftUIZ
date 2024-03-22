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
    public func _noListItemModification() -> some View {
        self._noListItemBackgroundOrTint()
            .listRowSeparator(.hidden)
            .listSectionSeparator(.hidden)
            .listRowInsets(.zero)
    }
    
    public func _noListItemBackgroundOrTint() -> some View {
        self
            .listItemTint(Optional<Color>.none)
            .listRowBackground(Color.clear)
            .introspect(.table) { (tableView: AppKitOrUIKitTableView) in
                #if os(iOS)
                _assignIfNotEqual(.clear, to: &tableView.backgroundColor)
                #elseif os(macOS)
                _assignIfNotEqual(.none, to: &tableView.focusRingType)
                _assignIfNotEqual(.none, to: &tableView.selectionHighlightStyle)
                #endif
            }
            .introspect(.listCell) { (cell: AppKitOrUIKitTableViewCell) in
                #if os(iOS)
                _assignIfNotEqual(.clear, to: &cell.backgroundColor)
                _assignIfNotEqual(.none, to: &cell.selectionStyle)
                #elseif os(macOS)
                _assignIfNotEqual(.none, to: &cell.focusRingType)
                #endif
            }
    }
}
