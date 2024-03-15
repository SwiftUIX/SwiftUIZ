//
// Copyright (c) Vatsal Manot
//

import _DVGraph
import Expansions
import SwiftUIX

public protocol _DVCanvasType: View {
    
}

public struct _DVCanvas<Content: View>: View, _DVCanvasType {
    @StateObject var graph = _DVGraph()
    
    public let content: Content
    
    public init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    
    public var body: some View {
        content
            ._modifier(_EstablishDynamicViewScope())
            .environment(\._dynamicViewGraph, graph)
            .task {
                Expansions.module.initialize()
            }
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
    
    public func override<Node: _DVConcreteAttribute>(
        _ atom: Node,
        with value: @escaping (Node) -> Node.AttributeEvaluator.Value
    ) -> some View {
        transformEnvironment(\._dynamicViewGraphContext) { context in
            context.attributeGraphOverrides[_DVConcreteAttributeGraph.Override(atom)] = AttributeOverride(value: value)
        }
    }
    
    public func override<Node: _DVConcreteAttribute>(
        _ atomType: Node.Type,
        with value: @escaping (Node) -> Node.AttributeEvaluator.Value
    ) -> some View {
        transformEnvironment(\._dynamicViewGraphContext) { context in
            context.attributeGraphOverrides[_DVConcreteAttributeGraph.Override(atomType)] = AttributeOverride(value: value)
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
