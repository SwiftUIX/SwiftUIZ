//
// Copyright (c) Vatsal Manot
//

@_spi(Internal) import SwiftUIX

public struct _ViewActionImplementation {
    let _name: any _ViewActionNameType
    let _actionType: Any.Type
    let _operation: (Any) throws -> Any
    
    public init<ActionGroup, ActionType>(
        _ name: _ViewActionName<ActionGroup, ActionType>,
        operation: @escaping (ActionType) -> Void
    ) {
        self._name = name
        self._actionType = ActionType.self
        
        fatalError()
    }
}

public struct _ImplementViewAction<ActionGroup: _ViewActionGroup>: View {
    public let implementation: _ViewActionImplementation
    
    public init<ActionType>(
        _ name: _ViewActionName<ActionGroup, ActionType>,
        operation: @escaping (ActionType) -> Void
    ) {
        self.implementation = .init(name, operation: operation)
    }
    
    public var body: some View {
        ZeroSizeView()
    }
}

extension Action {
    public init<ActionGroup, ActionType>(
        _ action: _ViewActionName<ActionGroup, ActionType>,
        operation: @escaping (ActionType) -> Void
    ) {
        self.init(_body: _ImplementViewAction(action, operation: operation))
    }
}
