//
// Copyright (c) Vatsal Manot
//

import Diagnostics
import Runtime
import Swallow
import SwiftUIX

public protocol _ShallowEnvironmentHydrationSurface {
    var staticViewTypeDescriptor: _StaticViewTypeDescriptor { get }
}

struct _HydrateShallowEnvironment<Content: View>: _ThinViewModifier {
    let values: _ShallowEnvironmentValues
    
    @ViewStorage var provider = _ShallowEnvironmentProvider()
    
    @State var foo: Bool = false
    
    func body(content: Content) -> some View {
        _UnaryViewTraitReader(_ShallowEnvironmentHydrationSurface.self) {
            content
                .environment(\._shallowEnvironmentProvider, provider)
                .id(foo)
        } action: { (surface: _ShallowEnvironmentHydrationSurface?) in
            if let surface {
                provider.hydrate(from: values, forSurface: surface)
                
                refreshOnceIfNeeded()
            }
        }
    }
    
    private func refreshOnceIfNeeded() {
        if !foo {
            DispatchQueue.main.async {
                foo = true
            }
        }
    }
}

extension View {
    public func _transformShallowEnvironment(
        _ transform: (inout _ShallowEnvironmentValues) -> Void
    ) -> some View {
        var values = _ShallowEnvironmentValues()
        
        transform(&values)
        
        return _modifier(_HydrateShallowEnvironment(values: values))
    }
}
