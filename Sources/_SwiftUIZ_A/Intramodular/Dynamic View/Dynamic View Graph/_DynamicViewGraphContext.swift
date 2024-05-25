//
// Copyright (c) Vatsal Manot
//

import CorePersistence
import Swallow

public protocol _DynamicViewGraphContextType: _opaque_DynamicViewGraphContextType {
    var _graph: (any _DynamicViewGraphType)? { get set }
}

public struct _DynamicViewGraphContext: _DynamicViewGraphContextType {
    public var _isInvalidInstance: Bool = true
    
    public weak var _graph: (any _DynamicViewGraphType)? {
        didSet {
            if _graph == nil {
                assertionFailure()
            }
        }
    }
    
    public var _opaque_dynamicViewGraph: _SwiftUIZ_A._AnyDynamicViewGraph? {
        get {
            self._graph
        } set {
            self._graph = newValue.map({ $0 as! (any _DynamicViewGraphType) })
        }
    }
    
    public var scope = _ViewGraphScopeID()
    public var _inheritance: [_ViewGraphNodeID] = []
    public var userInfo = UserInfo(_unscoped: ())
    
    public var graph: any _DynamicViewGraphType {
        get {
            _graph!
        } set {
            _graph = newValue
        }
    }
    
    public init(graph: (any _DynamicViewGraphType)?) {
        self._graph = graph
    }
}

extension EnvironmentValues {
    struct _ViewGraphContextKey: SwiftUI.EnvironmentKey {
        static let defaultValue = _DynamicViewGraphContext(graph: nil)
    }
        
    public var _viewGraphContext: _DynamicViewGraphContext {
        get {
            self[_ViewGraphContextKey.self]
        } set {
            self[_ViewGraphContextKey.self] = newValue
        }
    }
}

extension _DynamicViewGraphContext: ThrowingMergeOperatable {
    public mutating func mergeInPlace(
        with other: _DynamicViewGraphContext
    ) throws {
        assert(scope == other.scope)
        
        try self.userInfo.mergeInPlace(with: other.userInfo)
    }
}

extension _DynamicViewGraphContext {
    public var inheritance: [any _DynamicViewGraphNodeType] {
        precondition(!graph._isInvalidInstance)
        
        return _inheritance.map({ graph[$0] })
    }
}
