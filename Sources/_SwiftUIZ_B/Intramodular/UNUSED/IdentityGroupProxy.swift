//
// Copyright (c) Vatsal Manot
//

import Diagnostics
import SwiftUI

public struct IdentityGroupProxy: Equatable {
    weak var _resolver: _ViewIdentityResolver?
    
    let resolution: _ViewIdentity.Resolved?
    
    init(_resolver: _ViewIdentityResolver) {
        self._resolver = _resolver
        self.resolution = _resolver.resolution
    }
    
    public var children: Set<_ViewIdentity.ID> {
        resolution?.children ?? []
    }
    
    public static func == (lhs: Self, rhs: Self) -> Bool {
        guard let lhs = lhs._resolver, let rhs = rhs._resolver else {
            runtimeIssue(.unexpected)
            
            return false
        }
        
        return lhs === rhs
    }
}

extension IdentityGroupProxy {
    @TaskLocal static var current: IdentityGroupProxy?
}
