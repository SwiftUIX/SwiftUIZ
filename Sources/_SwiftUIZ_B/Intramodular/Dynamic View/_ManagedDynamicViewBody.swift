//
// Copyright (c) Vatsal Manot
//

import _DynamicViewGraph
import Diagnostics
import Runtime
@_spi(Internal) import SwiftUIX

@frozen
public struct _ManagedDynamicViewBody<Root: View, Content: View>: View {
    @Environment(\._dynamicViewGraph) private var _dynamicViewGraph: ViewGraph
    
    @usableFromInline
    let root: Root
    @usableFromInline
    let content: Content
    
    public init(
        root: Root,
        @ViewBuilder content: () -> Content
    ) {
        self.root = root
        self.content = content()
    }
    
    @StateObject private var bridge = _DynamicViewBridge()
    
    public var node: ViewGraph.Node {
        membership.node
    }
    
    @ViewStorage private var membership: ViewGraphMembership!
    
    public var body: some View {
        let _: Void? = _expectNoThrow {
            try _initializeIfNeeded()
        }
        
        Group {
            if !node.state.contains(.resolved) {
                let _: Void = reevaluate()
            }

            if node.state.contains(.resolved) {
                _UnaryViewReader(content) { view in
                    content
                }
            } else {                
                Text("Unresolved").onAppear {
                    if node.state.contains(.resolved) {
                        membership.objectWillChange.send()
                    }
                }
            }
        }
        .transformEnvironment(\._dynamicViewGraphContext) { context in
            do {
                context.graph = membership.graph
                context.inheritance.append(membership.node.id)
                
                for (key, attribute) in node.attributes {
                    context.insert(override: try attribute.__conversion(), withIdentifier: key)
                }
                
                try node.update()
            } catch {
                assertionFailure(error)
            }
        }
        .trait(
            _SwiftUIZ_DynamicViewReceiverContext.self,
            _SwiftUIZ_DynamicViewReceiverContext(bridge: bridge)
        )
        ._host(bridge)
    }
    
    @usableFromInline
    func _initializeIfNeeded() throws {
        if bridge.owner == nil {
            bridge.owner = self._dynamicViewGraph
        }
        
        guard bridge.descriptor == nil else {
            return
        }
        
        bridge.descriptor = try ViewTypeDescriptor(from: root)
        
        guard membership == nil else {
            return
        }
        
        membership = ViewGraphMembership(
            graph: self._dynamicViewGraph,
            bridge: bridge
        )
        
        DispatchQueue.main.async {
            bridge.objectWillChange.send()
        }
    }
    
    private func reevaluate() {
        do {
            try refreshAttributes()
            
            try node.update()
        } catch {
            
        }
    }
    
    private func refreshAttributes() throws {
        let mirror = InstanceMirror(root)!
        
        let attributes: [any _DVConcreteAttributeConvertible] = try withMutableScope([]) {
            try mirror._collectAttributes(into: &$0)
        }
        
        for attribute in attributes {
            node.attributes[DVAttributeNodeID(try attribute.__conversion(), overrideScopeKey: nil)] = attribute
        }
    }
}

extension ObservedObject: PropertyWrapper {
    
}

extension StateObject: PropertyWrapper {
    
}

extension InstanceMirror {
    // FIXME: SLOW
    func _collectAttributes(into result: inout [any _DVConcreteAttributeConvertible]) throws {
        return try forEachChild(
            conformingTo: (any PropertyWrapper).self
        ) { field in
            if let fieldValue = field.value as? (any _DVConcreteAttributeConvertible)  {
                let attribute: any _DVConcreteAttribute = try fieldValue.__conversion()
                
                result.append(fieldValue)
                
                guard attribute._isAttributeResolved else {
                    return
                }
            } else if let wrappedValue = field.value.wrappedValue as? (any ObservableObject) {
                if let mirror = InstanceMirror<Any>(wrappedValue) {
                    try mirror._collectAttributes(into: &result)
                }
            }
        } ingoring: {
            _ = $0
        }
    }
}
