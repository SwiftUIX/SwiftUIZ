//
// Copyright (c) Vatsal Manot
//

import Diagnostics
import Runtime
import SwiftUIX
@_spi(Internal) import _SwiftUIZ_A

public protocol _InterposedViewBody_ViewGraphInsertion: ObservableObject {
    var graph: (any _AnyViewHypergraphType)? { get }
    var insertedObject: any _AnyViewHypergraph.InterposeProtocol { get }
    
    func transformEnvironment(
        _ environment: inout EnvironmentValues
    )
}

extension _InterposedViewBody {
    @usableFromInline
    final class ViewGraphInsertion: _InterposedViewBody_ViewGraphInsertion {
        @usableFromInline
        weak var graph: (any _AnyViewHypergraphType)?
        
        @usableFromInline
        var insertedObject: any _AnyViewHypergraph.InterposeProtocol
        
        public var staticViewTypeDescriptor: _StaticViewTypeDescriptor {
            insertedObject.staticViewTypeDescriptor
        }
        
        init<V: View>(
            for view: V,
            in graph: (any _AnyViewHypergraphType)
        ) throws {
            assert(!graph._isInvalidInstance)
            
            self.graph = graph
            
            let typeDescriptor = try _StaticViewTypeDescriptor(from: type(of: view))
            
            self.insertedObject = _LightweightViewHypergraph.Interpose(
                graph: graph,
                typeDescriptor: typeDescriptor
            )
            
            graph.insert(insertedObject)
            
            try graph.prepare(insertedObject)
        }
        
        deinit {
            graph?.remove(insertedObject)
        }
        
        @usableFromInline
        func transformEnvironment(
            _ environment: inout EnvironmentValues
        ) {
            do {
                environment._interposeContext.graph = graph!
                environment._interposeContext._inheritance.append(insertedObject.id)
                
                for (key, property) in insertedObject.elementProperties {
                    try property.update(id: key, context: &environment._interposeContext)
                }
                
                try insertedObject.update()
            } catch {
                assertionFailure(error)
            }
        }
    }
}

extension _InterposedViewBodyProxy {
    private var _dynamicViewGraphRepresentation: (any _AnyViewHypergraph.InterposeProtocol)! {
        _storage?.graphInsertion.insertedObject
    }
        
    var _isViewBodyResolved: Bool {
        _dynamicViewGraphRepresentation.state.contains(.resolved)
    }
        
    func _resolveViewBodyUsing_HeavyweightViewHypergraph() throws {
        guard !_dynamicViewGraphRepresentation.state.contains(.resolved) else {
            return
        }
        
        let insertedObject = try storage.graphInsertion.insertedObject
        
        try storage.graphInsertion.graph?.prepare(insertedObject)
        
        insertedObject.elementProperties = try _extractConsumableElementProperties()
        
        try insertedObject.update()
    }
}

extension _InterposedViewBodyProxy {
    func _extractConsumableElementProperties() throws -> [_PGElementID: any _PropertyGraph.Consumable] {
        let mirror = InstanceMirror(root)!
        
        var properties: [any _PropertyGraph.Consumable] = try withMutableScope([]) {
            try mirror._collectConsumableElementProperties(into: &$0, context: graphContext)
        }
        
        properties = try properties.map({ try $0.__conversion(context: graphContext) })
        
        return try properties._mapToDictionaryWithUniqueKey {
            try $0._resolveShallowIdentifier(in: graphContext)
        }
    }
}

// MARK: - Internal

extension _InterposedViewBodyStorage {
    @AssociatedObject(.OBJC_ASSOCIATION_RETAIN)
    var graphInsertion: (any _InterposedViewBody_ViewGraphInsertion)!
}

extension InstanceMirror {
    // FIXME: SLOW
    package func _collectConsumableElementProperties(
        into result: inout [any _PropertyGraph.Consumable],
        context: EnvironmentValues._opaque_InterposeGraphContextProtocol
    ) throws {
        return try forEachChild(
            conformingTo: (any PropertyWrapper).self
        ) { field in
            if let fieldValue = field.value as? (any _PropertyGraph.Consumable) {
                guard !(type(of: fieldValue )._isHiddenConsumable) else {
                    return
                }
                
                let attribute: any _PropertyGraph.Consumable = try fieldValue.__conversion(context: context)
                
                result.append(fieldValue)
                
                guard try attribute._isConsumableResolved else {
                    return
                }
            } else if let wrappedValue = field.value.wrappedValue as? (any ObservableObject) {
                if let mirror = InstanceMirror<Any>(wrappedValue) {
                    try mirror._collectConsumableElementProperties(into: &result, context: context)
                }
            }
        } ingoring: {
            if $0 is (any _HeavyweightViewHypergraphElementRepresentingProperty) {
                assertionFailure("Ignored \($0)")
            }
            
            _ = $0
        }
    }
}

