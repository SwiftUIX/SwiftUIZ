//
// Copyright (c) Vatsal Manot
//

import Diagnostics
import Runtime
import Swallow
import SwiftUIX

class _SwiftUIX_ViewParameterProvisionContext {
    struct Key: Hashable {
        let key: PartialKeyPath<_SwiftUIX_ViewParameterKeys>
        let id: AnyHashable
    }
    
    var storage: [Key: Any] = [:]
    
    public var isEmpty: Bool {
        storage.isEmpty
    }
    
    init() {
        
    }
    
    func hydrate(
        from values: _SwiftUIX_ViewParameters,
        context: _SwiftUIZ_ParameterReceiverContext
    ) {
        for key in context.descriptor.parameters {
            storage[.init(key: key.key, id: key.id)] = values.storage[key.key]!
        }
    }
}

extension EnvironmentValues {
    @EnvironmentValue var _viewProvisionContext = _SwiftUIX_ViewParameterProvisionContext()
}

struct _SwiftUIZ_ParametrizeParametrizableView<Content: View>: View {
    let parameters: _SwiftUIX_ViewParameters
    let content: Content
    
    @ViewStorage var provisionContext = _SwiftUIX_ViewParameterProvisionContext()
    
    @State var foo: Bool = false
    
    var body: some View {
        _UnaryViewTraitReader(_SwiftUIZ_ParameterReceiverContext.self) {
            content
                .environment(\._viewProvisionContext, provisionContext)
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

