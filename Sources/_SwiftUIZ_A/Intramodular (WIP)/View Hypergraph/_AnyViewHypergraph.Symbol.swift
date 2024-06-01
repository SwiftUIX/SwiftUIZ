//
// Copyright (c) Vatsal Manot
//

import CorePersistence
import Swallow

extension _AnyViewHypergraph {
    public protocol SymbolType: Hashable, Sendable {
        
    }
    
    public enum Symbol<T>: _AnyViewHypergraph.SymbolType {
        case element(_HeavyweightViewHypergraphElementID)
        case staticElement(_HeavyweightViewHypergraphStaticElementID)
    }
    
    public enum AnySymbol: Hashable, Sendable {
        case element(_HeavyweightViewHypergraphElementID)
        case staticElement(_HeavyweightViewHypergraphStaticElementID)
        
        public init<T>(erasing x: _AnyViewHypergraph.Symbol<T>) {
            switch x {
                case .element(let x):
                    self = .element(x)
                case .staticElement(let x):
                    self = .staticElement(x)
            }
        }
    }
}

extension MutableDictionaryProtocol where DictionaryKey == _AnyViewHypergraph.AnySymbol {
    public subscript<T>(
        _ symbol: _AnyViewHypergraph.Symbol<T>
    ) -> DictionaryValue? {
        get {
            self[_AnyViewHypergraph.AnySymbol(erasing: symbol)]
        } set {
            self[_AnyViewHypergraph.AnySymbol(erasing: symbol)] = newValue
        }
    }
    
    public subscript<T>(
        _ symbol: _AnyViewHypergraph.Symbol<T>,
        default defaultValue: @autoclosure () -> DictionaryValue
    ) -> DictionaryValue {
        get {
            self[_AnyViewHypergraph.AnySymbol(erasing: symbol), default: defaultValue()]
        } set {
            self[_AnyViewHypergraph.AnySymbol(erasing: symbol)] = newValue
        }
    }
}
