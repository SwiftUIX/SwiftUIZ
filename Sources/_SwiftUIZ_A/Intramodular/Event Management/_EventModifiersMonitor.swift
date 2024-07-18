//
// Copyright (c) Vatsal Manot
//

import Combine
import SwiftUIX

#if os(macOS)
extension EventModifiers {
    public static var _currentlyActive: Self {
        EventModifiers(_appKitModifierFlags: NSEvent.modifierFlags)
    }
}
#else
extension EventModifiers {
    public static var _currentlyActive: Self {
        fatalError("unimplemented")
    }
}
#endif

/// Monitors changes to the current active `EventModifiers`.
public class _EventModifiersMonitor: ObservableObject {
    public static let shared = _EventModifiersMonitor()
    
    @Published private(set) var modifiers: EventModifiers = ._currentlyActive
    
    #if os(macOS)
    private var monitor: NSEventMonitor!
    #endif
    
    private init() {
        #if os(macOS)
        monitor = NSEventMonitor(context: .local, matching: .flagsChanged) { event -> NSEvent? in
            self.modifiers = ._currentlyActive
            
            return event
        }
        #endif
    }
}

// MARK: - Supplementary

@MainActor
extension View {
    public func disablesHitTesting(
        forModifiers modifiers: EventModifiers = []
    ) -> some View {
        withInlineObservedObject(_EventModifiersMonitor.shared) { monitor in
            allowsHitTesting(monitor.modifiers.intersection(modifiers).isEmpty)
        }
    }
}
