//
// Copyright (c) Vatsal Manot
//

import Diagnostics
import Runtime
@_spi(Internal) import SwiftUIX
@_spi(Internal) import _SwiftUIZ_A

@usableFromInline
final class _DynamicViewGraphInsertion: ObservableObject {
    weak var graph: (any _DynamicViewGraphType)?
    
    var node: any _DynamicViewGraphNodeType
    
    public var staticViewTypeDescriptor: _StaticViewTypeDescriptor {
        node.staticViewTypeDescriptor
    }
    
    init<V: View>(
        for view: V,
        in graph: (any _DynamicViewGraphType)
    ) throws {
        assert(!graph._isInvalidInstance)
        
        self.graph = graph
        
        let typeDescriptor = try _StaticViewTypeDescriptor(from: type(of: view))
        
        self.node = _DynamicViewGraphLite.Node(
            graph: graph,
            typeDescriptor: typeDescriptor
        )
        
        graph.insert(node)
        
        try graph.prepare(node)
    }
    
    deinit {
        graph?.remove(node)
    }
    
    @MainActor(unsafe)
    func transformEnvironment(
        _ environment: inout EnvironmentValues
    ) {
        do {
            environment._viewGraphContext.graph = graph!
            environment._viewGraphContext._inheritance.append(node.id)
            
            for (key, property) in node.elementProperties {
                try property.update(id: key, context: &environment._viewGraphContext)
            }
            
            try node.update()
        } catch {
            assertionFailure(error)
        }
    }
}

extension _DynamicViewProxy {
    private var _dynamicViewGraphNode: (any _DynamicViewGraphNodeType)! {
        _storage?._dynamicViewGraphInsertion.node
    }
        
    var _isViewBodyResolved: Bool {
        _dynamicViewGraphNode.state.contains(.resolved)
    }
        
    func _resolveViewBodyUsingDynamicViewGraph() throws {
        guard !_dynamicViewGraphNode.state.contains(.resolved) else {
            return
        }
        
        let node = try storage._dynamicViewGraphInsertion.node
        
        try storage._dynamicViewGraphInsertion.graph?.prepare(node)
        
        node.elementProperties = try _extractConsumableElementProperties()
        
        try node.update()
    }
}

extension _DynamicViewProxy {
    func _extractConsumableElementProperties() throws -> [_ViewAttributeID: any _ConsumableDynamicViewElementProperty] {
        let mirror = InstanceMirror(root)!
        
        var properties: [any _ConsumableDynamicViewElementProperty] = try withMutableScope([]) {
            try mirror._collectConsumableElementProperties(into: &$0, context: _dynamicViewGraphContext)
        }
        
        properties = try properties.map({ try $0.__conversion(context: _dynamicViewGraphContext) })
        
        return try properties._mapToDictionaryWithUniqueKey {
            try $0._resolveShallowIdentifier(in: _dynamicViewGraphContext)
        }
    }
}

// MARK: - Internal

extension _DynamicViewBodyStorage {
    @AssociatedObject(.OBJC_ASSOCIATION_RETAIN)
    var _dynamicViewGraphInsertion: _DynamicViewGraphInsertion!
}

extension _DynamicViewBridge: _ShallowEnvironmentHydrationSurface {
    public var staticViewTypeDescriptor: _StaticViewTypeDescriptor {
        bodyStorage._dynamicViewGraphInsertion.node.staticViewTypeDescriptor
    }
}
