//
// Copyright (c) Vatsal Manot
//

import Runtime
import Swallow

struct _ViewActionConsumer: Identifiable {
    typealias ID = _TypeAssociatedID<Self, UUID>
    
    let id = ID()
}

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

struct _ViewActionDescriptor {
    struct Parameter: Identifiable {
        let id: AnyHashable
    }
    
    let id: ViewActionTypeIdentifier
    let action: any _ViewAction
    var parameters: [Parameter]
    
    init(from action: any _ViewAction) throws {
        let mirror = try AnyNominalOrTupleMirror(reflecting: action)
        
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

struct _ViewActionsContext: Hashable {
    var consumer: _ViewActionConsumer.ID?
    var knownTypes: Set<ViewActionTypeIdentifier> = []
    
    init() {
        
    }
}

extension EnvironmentValues {
    @EnvironmentValue
    var viewActionsContext = _ViewActionsContext()
}
