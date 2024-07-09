//
// Copyright (c) Vatsal Manot
//

import Runtime
import SwiftUI

/// A view that's loaded invisibly in the background.
@_alwaysEmitConformanceMetadata
public protocol _InvisibleAppView: Initiable, View {
    
}

private class _InvisibleAppViewIndex: ObservableObject {
    static let shared = _InvisibleAppViewIndex()
    
    @_StaticMirrorQuery(type: (any _InvisibleAppView).self)
    private static var allCases: [any _InvisibleAppView.Type]
    
    final class Item: Identifiable, ObservableObject {
        let id = _AutoIncrementingIdentifier<Item>()
        
        @Published var host: ItemHost.ID?
        
        let owner: _InvisibleAppViewIndex
        let view: any _InvisibleAppView.Type
        
        init(owner: _InvisibleAppViewIndex, _ view: any _InvisibleAppView.Type) {
            self.owner = owner
            self.view = view
        }
    }
    
    class ItemHost: Identifiable {
        let id: AnyHashable = _AutoIncrementingIdentifier<ItemHost>()
        
        var item: _InvisibleAppViewIndex.Item
        
        init(item: _InvisibleAppViewIndex.Item) {
            self.item = item
            
            if item.host == nil {
                item.host = id
            }
        }
        
        deinit {
            let item = item
            
            item.host = nil
            
            DispatchQueue.main.async {
                item.owner.objectWillChange.send()
            }
        }
    }
    
    private(set) var items: [Item]!
    
    private init() {
        self.items = _InvisibleAppViewIndex.allCases.map({ Item(owner: self, $0) })
    }
}

public struct _InvisibleAppViewIndexer: View {
    @ObservedObject private var index: _InvisibleAppViewIndex = .shared
    
    @ViewStorage private var items: IdentifierIndexingArrayOf<_InvisibleAppViewIndex.ItemHost> = []
    
    public init() {
        
    }
    
    public var body: some View {
        ZStack {
            ForEach(index.items) { (item: _InvisibleAppViewIndex.Item) in
                Group {
                    if let hostedItem = self[item] {
                        ZeroSizeView().background {
                            ZStack {
                                hostedItem.item.view.init().eraseToAnyView()
                            }
                        }
                    }
                }
                .id(item.host)
            }
        }
        .clipped()
        .hidden()
    }
    
    private subscript(
        _ item: _InvisibleAppViewIndex.Item
    ) -> _InvisibleAppViewIndex.ItemHost? {
        get {
            if let host = item.host {
                return items[id: host]
            } else {
                let result = _InvisibleAppViewIndex.ItemHost(item: item)
                
                self.items.append(result)
                
                return result
            }
        }
    }
}
