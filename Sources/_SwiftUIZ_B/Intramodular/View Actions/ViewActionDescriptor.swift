//
// Copyright (c) Vatsal Manot
//

import Runtime
import SwiftUIX

struct _ViewActionDescriptor {
    struct Parameter: Identifiable {
        let id: AnyHashable
    }
    
    let id: ViewActionTypeIdentifier
    let action: any _ViewAction
    var parameters: [Parameter]
    
    init(from action: any _ViewAction) throws {
        let mirror = try InstanceMirror(reflecting: action)
        
        var parameters: [Parameter] = []
        
        for field in mirror.fields {
            if let parameter = mirror[field] as? _ViewActionParameter<Any> {
                parameters.append(.init(id: parameter.id))
            }
        }
        
        self.id = .init(_actionType: type(of: action))
        self.action = action
        self.parameters = parameters
    }
}
