//
// Copyright (c) Vatsal Manot
//

#if os(iOS) || os(macOS) || os(tvOS) || os(visionOS)

import Merge
import Swift
@_spi(Internal) import SwiftUIX

public struct _SidebarProxy {
    private weak var window: AppKitOrUIKitWindow?
}

public final class _SidebarProxyCoordinator: ObservableObject {
    public static let shared = _SidebarProxyCoordinator()
    
    @_FlipFlopDisabled(within: .milliseconds(400)) public var dirty: Bool = false
    
    fileprivate init() {
        
    }
}

#if os(macOS)
extension _SidebarProxy {
    public static var _keyActive: Self {
        .init(window: NSApp.keyWindow)
    }
    
    public func open() {
        _open(attempt: 0)
    }
    
    private func _open(attempt: Int) {
        guard
            let splitView = NSApp.windows.first(byUnwrapping: { $0._SwiftUIX_nearestResponder(ofKind: NSSplitView.self) }),
            let splitViewController = splitView.delegate as? NSSplitViewController
        else {
            _SidebarProxyCoordinator.shared.dirty = true
            
            guard let window = NSApplication.shared.firstKeyWindow else {
                return
            }
            
            if attempt == 0 {
                window._incrementDecrementWindowSize()
                
                if let windowContentView = window.contentView, windowContentView.subviews.count > 0 {
                    DispatchQueue.main.async {
                        windowContentView._SwiftUIX_setNeedsLayout()
                        windowContentView._SwiftUIX_layoutIfNeeded()
                        
                        self._open(attempt: 1)
                    }
                }
            }
            
            return
        }
        
        if splitViewController._isFucked {
            _withoutAppKitOrUIKitAnimation {
                unhide()
                
                splitViewController.splitViewItems.map({ $0.viewController }).forEach {
                    $0.view._SwiftUIX_setNeedsLayout()
                    $0.view._SwiftUIX_layoutIfNeeded()
                }
            }
            
            _SidebarProxyCoordinator.shared.dirty = true
            
            DispatchQueue.main.async {
                if splitViewController._isFucked {
                    _SidebarProxyCoordinator.shared.dirty = true
                    
                    unhide()
                }
            }
        }
    }
    
    public func toggle() {
        NSApp.keyWindow?.firstResponder?.tryToPerform(#selector(NSSplitViewController.toggleSidebar(_:)), with: nil)
    }
    
    public func hide() {
        guard
            let splitView = NSApp.windows.first(byUnwrapping: { $0._SwiftUIX_nearestResponder(ofKind: NSSplitView.self) }),
            let splitViewController = splitView.delegate as? NSSplitViewController
        else {
            return
        }
        
        if !splitViewController.splitViewItems.allSatisfy({ $0.isCollapsed == true }) {
            NSApp.keyWindow?.firstResponder?.tryToPerform(#selector(NSSplitViewController.toggleSidebar(_:)), with: nil)
        }
    }
    
    public func unhide() {
        guard
            let splitView = NSApp.windows.first(byUnwrapping: { $0._SwiftUIX_nearestResponder(ofKind: NSSplitView.self) }),
            let splitViewController = splitView.delegate as? NSSplitViewController
        else {
            return
        }
        
        if splitViewController.splitViewItems.contains(where: { $0.isCollapsed == true }) {
            NSApp.keyWindow?.firstResponder?.tryToPerform(#selector(NSSplitViewController.toggleSidebar(_:)), with: nil)
        }
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

#if os(macOS)
extension NSSplitViewController {
    fileprivate var _isFucked: Bool {
        splitViewItems.contains(where: { $0.isCollapsed == true || $0.viewController.view.frame.size.isAreaZero })
    }
    
    fileprivate func _SwiftUIX_forceLayout() {
        self.splitView._SwiftUIX_setNeedsLayout()
        self.splitView._SwiftUIX_layoutIfNeeded()
        
        adjustChildViewControllersHeight()
    }
    
    fileprivate func adjustChildViewControllersHeight() {
        let splitViewHeight = self.splitView.bounds.height
        
        for childViewController in self.children {
            childViewController.view.invalidateIntrinsicContentSize()
            
            var frame = childViewController.view.frame
            frame.size.height = splitViewHeight
            childViewController.view.frame = frame
        }
    }
}

extension NSWindow {
    fileprivate func _incrementDecrementWindowSize() {
        let oldFrame = self.frame
        var frame = self.frame
        
        frame.size.width += 1
        frame.size.height += 1
        
        setFrame(frame, display: true, animate: true)
        setFrame(oldFrame, display: true, animate: true)
    }
}
#endif

#if os(macOS)
extension View {
    public func _navigationSplitViewColumnCollapsible(_ collapsible: Bool) -> some View {
        return introspect(.navigationSplitView, on: .macOS(.v13, .v14)) { splitView in
            guard let item = (splitView.delegate as? NSSplitViewController)?.splitViewItems.first else {
                return
            }
            
            if item.canCollapse != collapsible {
                item.canCollapse = collapsible
            }
        }
    }
}
#else
extension View {
    public func _navigationSplitViewColumnCollapsible(_ collapsible: Bool) -> some View {
        self
    }
}
#endif
