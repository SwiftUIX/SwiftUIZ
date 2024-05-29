//
// Copyright (c) Vatsal Manot
//

import Foundation
import SwallowMacrosClient
import SwiftUIX

public protocol _AnyDynamicViewGraphType: _AnyDynamicViewGraph {
    var _isInvalidInstance: Bool { get }
    
    subscript(_ id: _AnyDynamicViewGraph.InterposeID) -> any _AnyDynamicViewGraph.InterposeProtocol { get }
    
    func prepare(_ node: some _AnyDynamicViewGraph.InterposeProtocol) throws
    
    func insert(_ node: any _AnyDynamicViewGraph.InterposeProtocol)
    func remove(_ node: any _AnyDynamicViewGraph.InterposeProtocol)
    
    init()
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
