//
// Copyright (c) Vatsal Manot
//

import Diagnostics
import Runtime
import Swallow
import SwiftUIX

struct _SwiftUIZ_ParametrizeParametrizableView<Content: View>: View {
    let parameters: _SwiftUIX_ViewParameters
    let content: Content
    
    @ViewStorage var provisionContext = _DynamicViewContentProvisioningContext()
    
    @State var foo: Bool = false
    
    var body: some View {
        _UnaryViewTraitReader(_DynamicViewReceptor.self) {
            content
                .environment(\._dynamicViewProvisioningContext, provisionContext)
                .id(foo)
        } action: { receptionContext in
            if let receptionContext {
                provisionContext.hydrate(from: parameters, context: receptionContext)
                
                if !foo {
                    DispatchQueue.main.async {
                        foo = true
                    }
                }
            }
        }
    }
}

extension View {
    public func _viewParameters(
        _ parametrize: (inout _SwiftUIX_ViewParameters) -> Void
    ) -> some View {
        var parameters = _SwiftUIX_ViewParameters()
        
        parametrize(&parameters)
        
        return _SwiftUIZ_ParametrizeParametrizableView(parameters: parameters, content: self)
    }
}

