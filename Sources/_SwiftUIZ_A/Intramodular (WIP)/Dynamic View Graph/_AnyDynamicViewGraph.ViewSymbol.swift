//
// Copyright (c) Vatsal Manot
//

import CorePersistence
import Swallow

extension _AnyDynamicViewGraph {
    public protocol ViewSymbolType: Hashable, Sendable {
        
    }
    
    public enum ViewSymbol<T>: _AnyDynamicViewGraph.ViewSymbolType {
        case element(_DynamicViewElementID)
        case staticElement(_DynamicViewStaticElementID)
    }
    
    public enum AnyViewSymbol: Hashable, Sendable {
        case element(_DynamicViewElementID)
        case staticElement(_DynamicViewStaticElementID)
        
        public init<T>(erasing x: _AnyDynamicViewGraph.ViewSymbol<T>) {
            switch x {
                case .element(let x):
                    self = .element(x)
                case .staticElement(let x):
                    self = .staticElement(x)
            }
        }
    }
}
