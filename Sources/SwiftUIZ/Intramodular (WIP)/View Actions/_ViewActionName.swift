//
// Copyright (c) Vatsal Manot
//

import Swallow

public protocol _ViewActionNameType<ActionGroupType> {
    associatedtype ActionGroupType: _ViewActionGroup
    associatedtype ActionType
    
    var base: Any.Type { get }
}

public struct _ViewActionName<ActionGroupType: _ViewActionGroup, ActionType>: _ViewActionNameType {
    public let base: Any.Type
    
    @_spi(Internal)
    public init(base: Any.Type) {
        self.base = base
    }
}

public struct _ViewActionNameWithExtra<ActionGroupType: _ViewActionGroup, ActionType, Extra>: _ViewActionNameType {
    public let base: Any.Type
    
    @_spi(Internal)
    public init(base: Any.Type) {
        self.base = base
    }
}
