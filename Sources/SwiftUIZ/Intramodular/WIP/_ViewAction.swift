//
// Copyright (c) Vatsal Manot
//

import Swallow


public protocol _ViewAction<ActionGroup> {
    associatedtype ActionGroup: _ViewActionGroup
}

public struct ViewAction<ActionGroup: _ViewActionGroup>: _ViewAction {
    public let name: any _ViewActionNameType<ActionGroup>
    
    public init<ActionType>(
        _ name: _ViewActionName<ActionGroup, ActionType>,
        operation: () -> Void
    ) {
        self.name = name
    }
}

public protocol _ViewActionResultType {
    associatedtype Value
}

extension View {
    public func actions<ActionGroup: _ViewActionGroup, T>(
        for group: ActionGroup,
        @_ArrayBuilder<any _ViewAction<ActionGroup>> intents: () -> T
    ) -> some View {
        self
    }
    
    public func actions<T>(
        @_ArrayBuilder<any _ViewAction> intents: () -> T
    ) -> some View {
        self
    }
}
