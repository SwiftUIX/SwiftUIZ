//
// Copyright (c) Vatsal Manot
//

import Swallow
import SwiftUIX

public struct _ViewActionParametrizationExpr<ActionType, Parameter> {
    let keyPath: any ViewActionParameterKeyPathExpression<ActionType, Parameter>
    let parameter: Parameter
    
    public init<E: ViewActionParameterKeyPathExpression>(
        keyPath: E,
        parameter: E.Value
    ) where E.Root == ActionType, E.Value == Parameter {
        self.keyPath = keyPath
        self.parameter = parameter
    }
    
    public static func binding(
        _ keyPath: WritableKeyPath<ActionType, Parameter>,
        to parameter: Parameter
    ) -> Self {
        self.init(keyPath: keyPath, parameter: parameter)
    }
    
    init<T, U>(expr: T, value: U) {
        fatalError()
    }
}

public protocol ViewActionParameterKeyPathExpression<Root, Value> {
    associatedtype Root
    associatedtype Value
}

extension WritableKeyPath: ViewActionParameterKeyPathExpression {
    
}

infix operator <->

public func == <ActionType, ParameterType>(
    lhs: WritableKeyPath<ActionType, ParameterType>,
    rhs: ParameterType
) -> _ViewActionParametrizationExpr<ActionType, ParameterType> {
    .init(keyPath: lhs, parameter: rhs)
}

public func <-> <ActionType, ParameterType>(
    lhs: WritableKeyPath<ActionType, ParameterType>,
    rhs: ParameterType
) -> _ViewActionParametrizationExpr<ActionType, ParameterType> {
    .init(keyPath: lhs, parameter: rhs)
}

public func == <Expression: ViewActionParameterKeyPathExpression>(
    lhs: Expression,
    rhs: Expression.Value
) -> _ViewActionParametrizationExpr<Expression, Expression.Value> {
    _ViewActionParametrizationExpr<Expression, Expression.Value>(expr: lhs, value: rhs)
}

extension View {
    public func actions<ActionGroup: _ViewActionGroup, T>(
        for group: ActionGroup,
        @_ArrayBuilder<any _ViewAction<ActionGroup>> intents: () -> T
    ) -> some View {
        self
    }
    
    public func action<ActionGroupType: _ViewActionGroup, ActionType>(
        _ action: _ViewActionName<ActionGroupType, ActionType>,
        in group: ActionGroupType = .init(),
        operation: @escaping (ActionType) -> Void
    ) -> some View {
        background {
            _ImplementViewAction(action, operation: operation)
        }
    }
    
    public func action<ActionGroupType: _ViewActionGroup, ActionType>(
        _ action: _ViewActionName<ActionGroupType, ActionType>,
        in group: ActionGroupType = .init(),
        operation: @escaping (ActionType) -> Void,
        bind parameterExpr: (inout ActionType) -> Void
    ) -> some View {
        background {
            _ImplementViewAction(action, operation: operation)
        }
    }
}

@dynamicMemberLookup
public struct ViewActionBinder<ActionType> {
    public subscript<ParameterType>(
        dynamicMember keyPath: WritableKeyPath<ActionType, ParameterType>
    ) -> ParameterType {
        get {
            fatalError()
        } nonmutating set {
            
        }
    }
}
