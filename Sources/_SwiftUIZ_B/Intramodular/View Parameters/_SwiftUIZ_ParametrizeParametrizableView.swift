//
// Copyright (c) Vatsal Manot
//

import Diagnostics
import Runtime
import Swallow
import SwiftUIX

struct _SwiftUIZ_ParametrizeParametrizableView<Content: View>: View {
    let parameters: _SwiftUIZ_DynamicViewParameterList
    let content: Content
    
    @ViewStorage var provisioningContext = _SwiftUIZ_DynamicViewContentProvisioningContext()
    
    @State var foo: Bool = false
    
    var body: some View {
        _UnaryViewTraitReader(_SwiftUIZ_DynamicViewReceiverContext.self) {
            content
                .environment(\._dynamicViewProvisioningContext, provisioningContext)
                .id(foo)
        } action: { receptionContext in
            if let receptionContext {
                provisioningContext.hydrate(from: parameters, context: receptionContext)
                
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
        _ parametrize: (inout _SwiftUIZ_DynamicViewParameterList) -> Void
    ) -> some View {
        var parameters = _SwiftUIZ_DynamicViewParameterList()
        
        parametrize(&parameters)
        
        return _SwiftUIZ_ParametrizeParametrizableView(parameters: parameters, content: self)
    }
}

