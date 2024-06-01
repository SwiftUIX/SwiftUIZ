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
        
        @MainActor(unsafe)
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
        _storage?._viewGraphInsertion.insertedObject
    }
        
    var _isViewBodyResolved: Bool {
        _dynamicViewGraphRepresentation.state.contains(.resolved)
    }
        
    func _resolveViewBodyUsing_HeavyweightViewHypergraph() throws {
        guard !_dynamicViewGraphRepresentation.state.contains(.resolved) else {
            return
        }
        
        let insertedObject = try storage._viewGraphInsertion.insertedObject
        
        try storage._viewGraphInsertion.graph?.prepare(insertedObject)
        
        insertedObject.elementProperties = try _extractConsumableElementProperties()
        
        try insertedObject.update()
    }
}

extension _InterposedViewBodyProxy {
    func _extractConsumableElementProperties() throws -> [_ViewHyperpropertyID: any _ConsumableViewHypergraphElementProperty] {
        let mirror = InstanceMirror(root)!
        
        var properties: [any _ConsumableViewHypergraphElementProperty] = try withMutableScope([]) {
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
    var _viewGraphInsertion: (any _InterposedViewBody_ViewGraphInsertion)!
}

extension InstanceMirror {
    // FIXME: SLOW
    @MainActor(unsafe)
    package func _collectConsumableElementProperties(
        into result: inout [any _ConsumableViewHypergraphElementProperty],
        context: EnvironmentValues._opaque_InterposeContextProtocol
    ) throws {
        return try forEachChild(
            conformingTo: (any PropertyWrapper).self
        ) { field in
            if let fieldValue = field.value as? (any _ConsumableViewHypergraphElementProperty) {
                guard !(type(of: fieldValue )._isHiddenConsumable) else {
                    return
                }
                
                let attribute: any _ConsumableViewHypergraphElementProperty = try fieldValue.__conversion(context: context)
                
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

