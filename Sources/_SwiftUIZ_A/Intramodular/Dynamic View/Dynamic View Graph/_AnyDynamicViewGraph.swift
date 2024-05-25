//
// Copyright (c) Vatsal Manot
//

import Foundation
import SwallowMacrosClient
import SwiftUIX

public var __unsafe_ViewGraphType: _AnyDynamicViewGraph.Type!
public var __unsafe_EnvironmentValues_opaque_viewGraphContext_getter: (EnvironmentValues) -> (any _opaque_DynamicViewGraphContextType)? = { _ in
    nil
}

public var __unsafe_EnvironmentValues_opaque_viewGraphContext_setter: (inout EnvironmentValues, (any _opaque_DynamicViewGraphContextType)?) -> Void = { _, _ in
    fatalError()
}

public protocol _opaque_DynamicViewGraphContextType {
    var _isInvalidInstance: Bool { get set }
    
    var scope: _ViewGraphScopeID { get set }
    var _opaque_dynamicViewGraph: _AnyDynamicViewGraph? { get set }
}

extension EnvironmentValues {
    public var _opaque_ViewGraphContext: (any _opaque_DynamicViewGraphContextType)? {
        get {
            __unsafe_EnvironmentValues_opaque_viewGraphContext_getter(self)
        } set {
            __unsafe_EnvironmentValues_opaque_viewGraphContext_setter(&self, newValue)
        }
    }
}

@objc
open class _AnyDynamicViewGraph: NSObject, ObservableObject {
    public let _isInvalidInstance: Bool
    
    public required init(invalid: ()) {
        self._isInvalidInstance = true
        
        super.init()
    }
    
    public required override init() {
        self._isInvalidInstance = false
        
        super.init()
    }
}

#once {
    __unsafe_EnvironmentValues_opaque_viewGraphContext_getter = { environment in
        environment._viewGraphContext
    }
    __unsafe_EnvironmentValues_opaque_viewGraphContext_setter = { (environment: inout EnvironmentValues, newValue: (any _opaque_DynamicViewGraphContextType)?) in
        let context: _DynamicViewGraphContext = newValue.map({ $0 as! _DynamicViewGraphContext })!
        
        environment._viewGraphContext = context
    }
    
    if let type = NSClassFromString("_SwiftUIZ_DynamicViewGraph") as? _AnyDynamicViewGraph.Type {
        __unsafe_ViewGraphType = type
    } else if let type = NSClassFromString("_SwiftUIZ_DynamicViewGraphLite") as? _AnyDynamicViewGraph.Type {
        __unsafe_ViewGraphType = type.self
    } else {
        runtimeIssue("Failed to resolve `__unsafe_ViewGraphType`.")
    }
}
