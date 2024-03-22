//
// Copyright (c) Vatsal Manot
//

import _DynamicViewGraph
import SwiftUIX

public protocol _DynamicSceneContentContainerType: View {
    
}

public struct _DynamicSceneContentContainer<Content: View>: View, _DynamicSceneContentContainerType {
    @StateObject var graph = ViewGraph()
    
    public let content: Content
    
    public init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    
    public var body: some View {
        content
            ._modifier(_EstablishDynamicViewScope())
            .environment(\._dynamicViewGraph, graph)
    }
}

@MainActor
extension View {
    public func observe(
        _ onUpdate: @escaping @MainActor (_DVAttributeGraphSnapshot) -> Void
    ) -> some View {
        transformEnvironment(\._dynamicViewGraphContext) { context in
            context.attributeGraphObservers.append(_DVConcreteAttributeGraphContext.Observer(onUpdate: onUpdate))
        }
    }
    
    public func override<T: _DVConcreteAttribute>(
        _ x: T,
        with value: @escaping (T) -> T.AttributeEvaluator.Value
    ) -> some View {
        transformEnvironment(\._dynamicViewGraphContext) { context in
            context.attributeGraphOverrides[_DVConcreteAttributeGraph.Override(attribute: x)] = AttributeOverride(value: value)
        }
    }
    
    public func override<T: _DVConcreteAttribute>(
        _ type: T.Type,
        with value: @escaping (T) -> T.AttributeEvaluator.Value
    ) -> some View {
        transformEnvironment(\._dynamicViewGraphContext) { context in
            context.attributeGraphOverrides[_DVConcreteAttributeGraph.Override(attributeType: type)] = AttributeOverride(value: value)
        }
    }
}

@MainActor
public struct _EstablishDynamicViewScope<Content: View>: _ThinViewModifier {    
    @State private var scope = _DVConcreteAttributeGraph.Scope()
    
    public init() {
        
    }
    
    public func body(content: Content) -> some View {
        content.transformEnvironment(\._dynamicViewGraphContext) {
            $0.attributeGraphScope = scope
        }
    }
}
