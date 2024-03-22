//
// Copyright (c) Vatsal Manot
//

import SwiftUI

@MainActor
public final class _DVConcreteAttributeTransaction {
    private var _commit: (() -> Void)?
    
    public let key: DVAttributeNodeID
    
    @usableFromInline
    private(set) var terminationHandlers = ContiguousArray<@MainActor () -> Void>()
    @usableFromInline
    private(set) var isTerminated = false
    
    public init(key: DVAttributeNodeID, commit: @escaping () -> Void) {
        self.key = key
        self._commit = commit
    }
    
    public func commit() {
        let commit = _commit
        _commit = nil
        commit?()
    }
    
    @inlinable
    public func addTerminationHandler(_ action: @MainActor @escaping () -> Void) {
        guard !isTerminated else {
            return action()
        }
        
        terminationHandlers.append(action)
    }
    
    public func terminate() {
        isTerminated = true
        commit()
        
        let terminations = self.terminationHandlers
        self.terminationHandlers.removeAll()
        
        for termination in terminations {
            termination()
        }
    }
}
