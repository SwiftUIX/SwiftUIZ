//
// Copyright (c) Vatsal Manot
//

import CorePersistence
import SwiftUI

extension EnvironmentValues {
    public protocol _opaque_InterposeGraphContextProtocol {
        var _isInvalidInstance: Bool { get set }
        
        var scope: _ViewInterposeScope { get set }
        var _opaque_viewGraph: _AnyViewHypergraph? { get set }
    }
}

extension EnvironmentValues {
    public protocol _InterposeGraphContextProtocol: EnvironmentValues._opaque_InterposeGraphContextProtocol {
        var _graph: (any _AnyViewHypergraphType)? { get set }
    }
    
    public struct _InterposeGraphContext: EnvironmentValues._InterposeGraphContextProtocol {
        public var _isInvalidInstance: Bool = true
        
        public weak var _graph: (any _AnyViewHypergraphType)? {
            didSet {
                if _graph == nil {
                    assertionFailure()
                }
            }
        }
        
        public var _opaque_viewGraph: _SwiftUIZ_A._AnyViewHypergraph? {
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
                guard let result = _graph else {
                    runtimeIssue(_ViewInterposeError.viewGraphMissing)
                    
                    return _InvalidViewHypergraph()
                }
                
                return result
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
    private struct _InterposeGraphContextKey: SwiftUI.EnvironmentKey {
        static let defaultValue = EnvironmentValues._InterposeGraphContext(graph: nil)
    }
    
    public var _interposeContext: EnvironmentValues._InterposeGraphContext {
        get {
            self[_InterposeGraphContextKey.self]
        } set {
            self[_InterposeGraphContextKey.self] = newValue
        }
    }
}

extension EnvironmentValues._InterposeGraphContext: ThrowingMergeOperatable {
    public mutating func mergeInPlace(
        with other: EnvironmentValues._InterposeGraphContext
    ) throws {
        assert(scope == other.scope)
        
        try self.userInfo.mergeInPlace(with: other.userInfo)
    }
}

extension EnvironmentValues._InterposeGraphContext {
    public var inheritance: [any _AnyViewHypergraph.InterposeProtocol] {
        precondition(!graph._isInvalidInstance)
        
        return _inheritance.map({ graph[$0] })
    }
}

// MARK: - Auxiliary

extension EnvironmentValues {
    public var _opaque_interposeContext: (any EnvironmentValues._opaque_InterposeGraphContextProtocol)? {
        get {
            __unsafe_EnvironmentValues_opaque_interposeContext_getter(self)
        } set {
            __unsafe_EnvironmentValues_opaque_interposeContext_setter(&self, newValue)
        }
    }
}
