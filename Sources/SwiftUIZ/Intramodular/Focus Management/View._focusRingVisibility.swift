//
// Copyright (c) Vatsal Manot
//

import SwiftUIIntrospect
import SwiftUIX

#if os(iOS)
extension View {
    public func _focusRingVisibility(_ visibility: Visibility) -> some View {
        self
    }
}
#elseif os(macOS)
extension View {
    public func _focusRingVisibility(_ visibility: Visibility) -> some View {
        self.introspect(.textField, on: .macOS(.v11, .v12, .v13)) { (textField: AppKitOrUIKitTextField) in
            if visibility == .visible {
                textField.focusRingType = .exterior
            } else if visibility == .hidden {
                textField.focusRingType = .none
            } else {
                textField.focusRingType = .default
            }
        }
    }
}
#endif
