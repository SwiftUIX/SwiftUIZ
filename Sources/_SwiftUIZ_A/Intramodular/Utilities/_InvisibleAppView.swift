//
// Copyright (c) Vatsal Manot
//

import Runtime
import SwiftUIX
import SwallowMacrosClient

#once {
    Task(priority: .userInitiated) { @MainActor in
        _ = _InvisibleAppViewIndex.shared
    }
}

/// A view that's loaded invisibly in the background.
@_alwaysEmitConformanceMetadata
public protocol _InvisibleAppView: Initiable, View {
    
}

@_alwaysEmitConformanceMetadata
public protocol _InvisibleAppWindow: Initiable, View {
    
}

@MainActor
private class _InvisibleAppViewIndex: ObservableObject {
    static let shared = _InvisibleAppViewIndex()
    
    @_StaticMirrorQuery(#metatype((any _InvisibleAppView).self))
    private static var allViewTypes: [any _InvisibleAppView.Type]
    @_StaticMirrorQuery(#metatype((any _InvisibleAppWindow).self))
    private static var allWindowTypes: [any _InvisibleAppWindow.Type]
    
    private(set) var views: [View]!
    private(set) var windows: [Window]!
    
    @MainActor
    private init() {
        self.views = _InvisibleAppViewIndex.allViewTypes.map({ View(owner: self, swiftType: $0) })
        self.windows = _InvisibleAppViewIndex.allWindowTypes.map({ Window(owner: self, swiftType: $0) })
    }
}

public struct _InvisibleAppViewIndexer: View {
    @ObservedObject private var index: _InvisibleAppViewIndex = .shared
    
    @ViewStorage private var views: IdentifierIndexingArrayOf<_InvisibleAppViewIndex.ViewHost> = []
    
    public init() {
        
    }
    
    public var body: some View {
        ZStack {
            ForEach(index.views) { (element: _InvisibleAppViewIndex.View) in
                Group {
                    if let hostedItem = self[element] {
                        ZeroSizeView().background {
                            ZStack {
                                hostedItem.item.swiftType.init().eraseToAnyView()
                            }
                        }
                    }
                }
                .id(element.host)
            }
        }
        .clipped()
        .hidden()
    }
    
    private subscript(
        _ item: _InvisibleAppViewIndex.View
    ) -> _InvisibleAppViewIndex.ViewHost? {
        get {
            if let host = item.host {
                return views[id: host]
            } else {
                let result = _InvisibleAppViewIndex.ViewHost(item: item)
                
                self.views.append(result)
                
                return result
            }
        }
    }
}
extension _InvisibleAppViewIndex {
    final class View: Identifiable, ObservableObject {
        let id = _AutoIncrementingIdentifier<View>()
        
        @Published var host: ViewHost.ID?
        
        let owner: _InvisibleAppViewIndex
        let swiftType: any _InvisibleAppView.Type
        
        init(
            owner: _InvisibleAppViewIndex,
            swiftType: any _InvisibleAppView.Type
        ) {
            self.owner = owner
            self.swiftType = swiftType
        }
    }
    
    class ViewHost: Identifiable {
        let id: AnyHashable = _AutoIncrementingIdentifier<ViewHost>()
        
        var item: _InvisibleAppViewIndex.View
        
        init(item: _InvisibleAppViewIndex.View) {
            self.item = item
            
            if item.host == nil {
                item.host = id
            }
        }
        
        deinit {
            let item = item
            
            DispatchQueue.main.async {
                item.owner.objectWillChange.send()
                item.host = nil
            }
        }
    }
    
    final class Window: Identifiable, ObservableObject {
        let id = _AutoIncrementingIdentifier<Window>()
        
        let owner: _InvisibleAppViewIndex
        let swiftType: any _InvisibleAppWindow.Type
        
        private var host: WindowHost!
        
        @MainActor
        init(
            owner: _InvisibleAppViewIndex,
            swiftType: any _InvisibleAppWindow.Type
        ) {
            self.owner = owner
            self.swiftType = swiftType
            
            self.host = WindowHost(item: self)
        }
    }
    
    class WindowHost: Identifiable {
        let id: AnyHashable = _AutoIncrementingIdentifier<ViewHost>()
        
        var item: _InvisibleAppViewIndex.Window
        
        private var windowController: _WindowPresentationController<_HostedWindowContent>?
        
        @MainActor
        init(item: _InvisibleAppViewIndex.Window) {
            self.item = item
            
            host()
        }
        
        fileprivate struct _HostedWindowContent: SwiftUI.View {
            let host: WindowHost
            let content: AnyView
            
            @State private var foo: Bool = false
            
            var proxy: _InvisibleViewProxy {
                .init(_update: {
                    foo.toggle()
                })
            }
            
            var body: some SwiftUI.View {
                _InterposeSceneContent {
                    content
                        .environment(\._invisibleViewProxy, proxy)
                        .background(ZeroSizeView().id(foo))
                        .frame(width: 1, height: 1)
                        .clipped()
                        .fixedSize()
                        .opacity(0)
                        .allowsHitTesting(false)
                        .accessibility(hidden: true)
                }
                ._disableInvisibleAppViewIndexing()
            }
        }
        
        @MainActor
        func host() {
            let windowController = _WindowPresentationController(style: .plain) {
                _HostedWindowContent(
                    host: self,
                    content: item.swiftType.init().eraseToAnyView()
                )
            }
            
            self.windowController = windowController
            
            windowController.show()
            windowController.moveToBack()
            windowController.contentWindow.alphaValue = 0.0
            windowController.contentWindow.isHidden = true
            
            Task.detached(priority: .userInitiated) { @MainActor in
                windowController.contentWindow.alphaValue = 0.0
                windowController.contentWindow.isHidden = true
            }
        }
        
        deinit {
            let item = item
            
            DispatchQueue.main.async {
                item.owner.objectWillChange.send()
            }
        }
    }
}

public struct _InvisibleViewProxy {
    let _update: () -> Void
    
    public func update() {
        _update()
    }
}

extension EnvironmentValues {
    struct _InvisibleViewProxyKey: EnvironmentKey {
        typealias Value = _InvisibleViewProxy?
        
        static let defaultValue: _InvisibleViewProxy? = nil
    }
    
    var _invisibleViewProxy: _InvisibleViewProxy? {
        get {
            self[_InvisibleViewProxyKey.self]
        } set {
            self[_InvisibleViewProxyKey.self] = newValue
        }
    }
}

public struct _InvisibleViewReader<Content: View>: View {
    @Environment(\._invisibleViewProxy) var _invisibleViewProxy
    
    let content: (_InvisibleViewProxy) -> Content
    
    public init(content: @escaping (_InvisibleViewProxy) -> Content) {
        self.content = content
    }
    
    public var body: some View {
        content(_invisibleViewProxy!)
    }
}
