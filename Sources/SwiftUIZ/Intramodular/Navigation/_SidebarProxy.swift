//
// Copyright (c) Vatsal Manot
//

#if os(iOS) || os(macOS) || os(tvOS) || os(visionOS)

import Swift
import SwiftUI

public struct _SidebarProxy {
    private weak var window: AppKitOrUIKitWindow?
}

#if os(macOS)
extension _SidebarProxy {
    public static var _keyActive: Self {
        .init(window: NSApp.keyWindow)
    }
    
    public func open() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            guard let nsSplitView = findNSSplitView(view: NSApp.windows.first?.contentView), let controller = nsSplitView.delegate as? NSSplitViewController else {
                return
            }
            if controller.splitViewItems.first?.isCollapsed == true {
                toggle()
            }
        }
    }
    
    public func toggle() {
        NSApp.keyWindow?.firstResponder?.tryToPerform(#selector(NSSplitViewController.toggleSidebar(_:)), with: nil)
    }
    
    private func findNSSplitView(view: NSView?) -> NSSplitView? {
        var queue = [NSView]()
        if let root = view {
            queue.append(root)
        }
        while !queue.isEmpty {
            let current = queue.removeFirst()
            if current is NSSplitView {
                return current as? NSSplitView
            }
            for subview in current.subviews {
                queue.append(subview)
            }
        }
        return nil
    }
}
#else
extension _SidebarProxy {
    public static var _keyActive: Self {
        .init(window: nil)
    }
    
    public func open() {
        
    }
    
    public func toggle() {
        
    }
}
#endif

#endif

