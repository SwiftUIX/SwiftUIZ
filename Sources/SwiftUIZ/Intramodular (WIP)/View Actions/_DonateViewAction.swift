//
// Copyright (c) Vatsal Manot
//

import Runtime
import Swallow

public struct ViewActionTypeIdentifier: Hashable {
    @_HashableExistential
    public var _actionType: Any.Type
}


struct _ViewActionInitializer: Identifiable {
    let id: ViewActionTypeIdentifier
    let initializer: () -> any _ViewAction
}

public struct _DonateViewActionInitializerGroup {
    
    var initializers: IdentifierIndexingArrayOf<_ViewActionInitializer>
}

public struct _ViewActionParametrization {
    let parametrize: (inout any _ViewAction) -> Void
}


struct _PartiallyParametrizedViewAction: _PartiallyEquatable {
    let action: ViewActionTypeIdentifier
    let parameters: [_ViewActionDescriptor.Parameter.ID: Any]
    
    public func isEqual(to other: Self) -> Bool? {
        action == other.action && _isKnownEqual(parameters, other.parameters)
    }
}

public struct _ParametrizeViewAction: ViewModifier {
    @Environment(\.viewActionsContext) var viewActionsContext
    
    let parametrization: _ViewActionParametrization
    
    public func body(content: Content) -> some View {
        
    }
    
    func parametrizeAction() {
        // parametrization.parametrize(action)
    }
}
