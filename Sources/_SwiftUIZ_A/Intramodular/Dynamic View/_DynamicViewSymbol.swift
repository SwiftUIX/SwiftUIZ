//
// Copyright (c) Vatsal Manot
//

import CorePersistence
import Swallow

public protocol _DynamicViewSymbolType: Hashable, Sendable {
    
}

public enum _DynamicViewSymbol<T>: _DynamicViewSymbolType {
    case element(_DynamicViewElementID)
    case staticElement(_DynamicViewStaticElementID)
}

public enum _AnyDynamicViewSymbol: Hashable, Sendable {
    case element(_DynamicViewElementID)
    case staticElement(_DynamicViewStaticElementID)
    
    public init<T>(erasing x: _DynamicViewSymbol<T>) {
        switch x {
            case .element(let x):
                self = .element(x)
            case .staticElement(let x):
                self = .staticElement(x)
        }
    }
}
