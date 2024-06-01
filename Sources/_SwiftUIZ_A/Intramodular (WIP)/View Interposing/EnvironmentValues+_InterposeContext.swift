//
// Copyright (c) Vatsal Manot
//

import CorePersistence
import SwiftUI

extension EnvironmentValues {
    public protocol _InterposeContextProtocol: EnvironmentValues._opaque_InterposeContextProtocol {
        var _graph: (any _AnyViewHypergraphType)? { get set }
    }

    public struct _InterposeContext: EnvironmentValues._InterposeContextProtocol {
        public var _isInvalidInstance: Bool = true
        
        public weak var _graph: (any _AnyViewHypergraphType)? {
            didSet {
                if _graph == nil {
                    assertionFailure()
                }
            }
        }
        
        public var _opaque_dynamicViewGraph: _SwiftUIZ_A._AnyViewHypergraph? {
            get {
                self._graph
            } set {
                self._graph = newValue.map({ $0 as! (any _AnyViewHypergraphType) })
            }
        }
        
        public var scope = _ViewInterposeScope()
        public var _inheritance: [_AnyViewHypergraph.InterposeID] = []
        public var userInfo = UserInfo(_unscoped: ())
        
        public var graph: any _AnyViewHypergraphType {
            get {
                _graph!
            } set {
                _graph = newValue
            }
        }
        
        public init(graph: (any _AnyViewHypergraphType)?) {
            self._graph = graph
        }
    }
}

extension EnvironmentValues {
    private struct _InterposeContextKey: SwiftUI.EnvironmentKey {
        static let defaultValue = EnvironmentValues._InterposeContext(graph: nil)
    }
    
    public var _interposeContext: EnvironmentValues._InterposeContext {
        get {
            self[_InterposeContextKey.self]
        } set {
            self[_InterposeContextKey.self] = newValue
        }
    }
}

extension EnvironmentValues._InterposeContext: ThrowingMergeOperatable {
    public mutating func mergeInPlace(
        with other: EnvironmentValues._InterposeContext
    ) throws {
        assert(scope == other.scope)
        
        try self.userInfo.mergeInPlace(with: other.userInfo)
    }
}

extension EnvironmentValues._InterposeContext {
    public var inheritance: [any _AnyViewHypergraph.InterposeProtocol] {
        precondition(!graph._isInvalidInstance)
        
        return _inheritance.map({ graph[$0] })
    }
}
