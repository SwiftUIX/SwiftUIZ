//
// Copyright (c) Vatsal Manot
//

import Diagnostics
import Runtime
import SwiftUIX
@_spi(Internal) import _SwiftUIZ_A

public protocol _InterposedViewBody_GraphInsertion: ObservableObject {
    var graph: (any _AnyDynamicViewGraphType)? { get }
    var node: any _AnyDynamicViewGraph.InterposeProtocol { get }
    
    func transformEnvironment(
        _ environment: inout EnvironmentValues
    )
}

extension _InterposedViewBody {
    @usableFromInline
    final class GraphInsertion: _InterposedViewBody_GraphInsertion {
        @usableFromInline
        weak var graph: (any _AnyDynamicViewGraphType)?
        
        @usableFromInline
        var node: any _AnyDynamicViewGraph.InterposeProtocol
        
        public var staticViewTypeDescriptor: _StaticViewTypeDescriptor {
            node.staticViewTypeDescriptor
        }
        
        init<V: View>(
            for view: V,
            in graph: (any _AnyDynamicViewGraphType)
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
        @usableFromInline
        func transformEnvironment(
            _ environment: inout EnvironmentValues
        ) {
            do {
                environment._interposeContext.graph = graph!
                environment._interposeContext._inheritance.append(node.id)
                
                for (key, property) in node.elementProperties {
                    try property.update(id: key, context: &environment._interposeContext)
                }
                
                try node.update()
            } catch {
                assertionFailure(error)
            }
        }
    }
}

extension _InterposedViewBodyProxy {
    private var _dynamicViewGraphNode: (any _AnyDynamicViewGraph.InterposeProtocol)! {
        _storage?.dynamicViewGraphInsertion.node
    }
        
    var _isViewBodyResolved: Bool {
        _dynamicViewGraphNode.state.contains(.resolved)
    }
        
    func _resolveViewBodyUsingDynamicViewGraph() throws {
        guard !_dynamicViewGraphNode.state.contains(.resolved) else {
            return
        }
        
        let node = try storage.dynamicViewGraphInsertion.node
        
        try storage.dynamicViewGraphInsertion.graph?.prepare(node)
        
        node.elementProperties = try _extractConsumableElementProperties()
        
        try node.update()
    }
}

extension _InterposedViewBodyProxy {
    func _extractConsumableElementProperties() throws -> [_ViewAttributeID: any _ConsumableDynamicViewGraphElementProperty] {
        let mirror = InstanceMirror(root)!
        
        var properties: [any _ConsumableDynamicViewGraphElementProperty] = try withMutableScope([]) {
            try mirror._collectConsumableElementProperties(into: &$0, context: _dynamicViewGraphContext)
        }
        
        properties = try properties.map({ try $0.__conversion(context: _dynamicViewGraphContext) })
        
        return try properties._mapToDictionaryWithUniqueKey {
            try $0._resolveShallowIdentifier(in: _dynamicViewGraphContext)
        }
    }
}

// MARK: - Internal

extension _InterposedViewBodyStorage {
    @AssociatedObject(.OBJC_ASSOCIATION_RETAIN)
    var dynamicViewGraphInsertion: (any _InterposedViewBody_GraphInsertion)!
}

extension InstanceMirror {
    // FIXME: SLOW
    @MainActor(unsafe)
    package func _collectConsumableElementProperties(
        into result: inout [any _ConsumableDynamicViewGraphElementProperty],
        context: EnvironmentValues._opaque_InterposeContextProtocol
    ) throws {
        return try forEachChild(
            conformingTo: (any PropertyWrapper).self
        ) { field in
            if let fieldValue = field.value as? (any _ConsumableDynamicViewGraphElementProperty) {
                guard !(type(of: fieldValue )._isHiddenConsumableDynamicViewElementProperty) else {
                    return
                }
                
                let attribute: any _ConsumableDynamicViewGraphElementProperty = try fieldValue.__conversion(context: context)
                
                result.append(fieldValue)
                
                guard try attribute._isAttributeResolved else {
                    return
                }
            } else if let wrappedValue = field.value.wrappedValue as? (any ObservableObject) {
                if let mirror = InstanceMirror<Any>(wrappedValue) {
                    try mirror._collectConsumableElementProperties(into: &result, context: context)
                }
            }
        } ingoring: {
            if $0 is (any _DynamicViewGraphElementRepresentingProperty) {
                assertionFailure("Ignored \($0)")
            }
            
            _ = $0
        }
    }
}

