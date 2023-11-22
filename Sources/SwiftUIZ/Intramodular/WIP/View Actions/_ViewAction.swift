//
// Copyright (c) Vatsal Manot
//

import Swallow

/// This type is **internal**.
public protocol _ViewAction<ActionGroup>: Initiable {
    associatedtype ActionGroup: _ViewActionGroup
}

extension _ViewAction {
    public typealias Parameter<T> = _ViewActionParameter<T>
}


/// This type is **internal**.
public protocol _ViewActionResultType {
    associatedtype Value
}
