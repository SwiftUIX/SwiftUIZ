//
// Copyright (c) Vatsal Manot
//

import Swallow
@_spi(Internal) import SwiftUIX

#if os(macOS)
@frozen
public struct _WindowDrawerConfiguration<Content: View> {
    let isPresented: Binding<Bool>
    let content: () -> Content
    let windowEdge: Edge
}

struct _InsertWindowDrawerPresenter<DrawerContent: View>: ViewModifier {
    let configuration: _WindowDrawerConfiguration<DrawerContent>
    
    @State private var drawer = _NSHostingDrawerController<DrawerContent>()
    
    func body(content: Content) -> some View {
        content
            .background(presenter)
    }
    
    private var presenter: some View {
        withAppKitOrUIKitViewController { viewController in
            if let viewController {
                let _: Void = { [weak viewController] in
                    self.drawer.configuration = configuration
                    self.drawer.window = viewController!._SwiftUIX_nearestWindow!
                }()
                
                ZeroSizeView()
                    ._onAppearAndChange(of: configuration.isPresented.wrappedValue) { isPresented in
                        if isPresented && !drawer.isPresented {
                            drawer.open()
                        } else if !isPresented && drawer.isPresented {
                            drawer.close()
                        }
                    }
            } else {
                ZeroSizeView()
            }
        }
    }
}

@objc protocol _NSDrawerProtocol: NSObjectProtocol {
    init(contentSize: NSSize, preferredEdge: NSRectEdge)
    
    var parentWindow: NSWindow? { get set }
    var contentView: NSView? { get set }
    
    func open()
    func open(on edge: NSRectEdge)
    func close()
    
    var state: Int { get }
}

extension View {
    public func _windowDrawer<Content: View>(
        isPresented: Binding<Bool>,
        edge: Edge = .trailing,
        content: @escaping () -> Content
    ) -> some View {
        modifier(
            _InsertWindowDrawerPresenter(
                configuration: _WindowDrawerConfiguration(
                    isPresented: isPresented,
                    content: content,
                    windowEdge: edge
                )
            )
        )
    }
}

private class _NSHostingDrawerController<Content: View>: NSObject, NSDrawerDelegate {
    fileprivate var window: AppKitOrUIKitWindow?
    fileprivate var configuration: _WindowDrawerConfiguration<Content>! {
        didSet {
            _contentViewController?.mainView = configuration.content()
        }
    }
    
    private var drawer: _NSDrawerProtocol?
    private var _contentViewController: CocoaHostingController<Content>?
    
    public var isPresented: Bool {
        drawer != nil
    }
    
    private func _setUpDrawer() {
        let nsDrawerClass = NSClassFromString("NSDrawer") as! NSObject.Type
        guard drawer == nil else {
            return
        }
        
        let drawerClass = unsafeBitCast(nsDrawerClass, to: _NSDrawerProtocol.Type.self)
        let contentViewController = CocoaHostingController<Content>(mainView: configuration.content())
        
        self._contentViewController = contentViewController
        
        contentViewController.view._SwiftUIX_setNeedsLayout()
        contentViewController.view._SwiftUIX_layoutIfNeeded()
        
        contentViewController._configureSizingOptions(for: AppKitOrUIKitWindow.self)
        
        assert(!contentViewController.preferredContentSize.isAreaZero)
        
        let drawer: _NSDrawerProtocol = drawerClass.init(
            contentSize: contentViewController.preferredContentSize,
            preferredEdge: NSRectEdge(configuration.windowEdge)
        )
        
        drawer.contentView = contentViewController.view
        drawer.parentWindow = self.window!
        
        self.drawer = drawer
    }
    
    func open() {
        guard drawer == nil else {
            return
        }
        
        _setUpDrawer()
        
        self.drawer!.open()
    }
    
    func close() {
        guard let drawer else {
            return
        }
        
        drawer.close()
        
        self.drawer = nil
    }
    
    func drawerDidOpen(_ notification: Notification) {
        configuration.isPresented.wrappedValue = true
    }
    
    func drawerDidClose(_ notification: Notification) {
        configuration.isPresented.wrappedValue = false
        
        self.drawer = nil
    }
}
#endif
