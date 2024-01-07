//
// Copyright (c) Vatsal Manot
//

import SwiftUIIntrospect
import SwiftUIX

#if os(iOS) || os(tvOS) || os(visionOS)
extension View {
    public func _introspectAppKitOrUIKitButton(
        _ action: @escaping (AppKitOrUIKitButton) -> Void
    ) -> some View {
        self
    }

    public func _introspectAppKitOrUIKitWindow(
        noDelay: Bool = false,
        _ action: @escaping (AppKitOrUIKitWindow) -> Void
    ) -> some View {
        introspect(.window, on: .iOS(.v13, .v14, .v15, .v16, .v17)) { view in
            DispatchQueue.main.async {
                action(view)
            }
        }
    }
}
#elseif os(macOS)
extension View {
    public func _introspectAppKitOrUIKitButton(
        _ action: @escaping (AppKitOrUIKitButton) -> Void
    ) -> some View {
        introspect(.button, on: .macOS(.v11, .v12, .v13, .v14)) { view in
            DispatchQueue.main.async {
                action(view)
            }
        }
    }
    
    public func _introspectAppKitOrUIKitWindow(
        noDelay: Bool = false,
        _ action: @escaping (AppKitOrUIKitWindow) -> Void
    ) -> some View {
        introspect(.window, on: .macOS(.v11, .v12, .v13, .v14)) { view in
            if !noDelay {
                DispatchQueue.main.async {
                    action(view)
                }
            } else {
                action(view)
            }
        }
    }
}
#endif

// MARK: - Supplementary

#if os(macOS)
extension View {
    public func _disableAppKitOrUIKitWindowResizability() -> some View {
        _introspectAppKitOrUIKitWindow {
            $0.styleMask.remove(.resizable)
        }
    }
}
#else
extension View {
    public func _disableAppKitOrUIKitWindowResizability() -> some View {
        self
    }
}
#endif
