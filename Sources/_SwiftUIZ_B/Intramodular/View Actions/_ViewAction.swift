//
// Copyright (c) Vatsal Manot
//

import Swallow

/// This type is **internal**.
public protocol _ViewAction<ActionGroup>: Initiable {
    associatedtype ActionGroup: _ViewActionGroup
}

/// This type is **internal**.
public protocol _ViewActionGroup: Initiable {
    
}

/// This type is **internal**.
public protocol _ViewActionResultType {
    associatedtype Value
}

// MARK: - Supplementary

extension _ViewAction {
    public typealias Parameter<T> = _ViewActionParameter<T>
}

public enum _ViewActionGroups {
    
}
