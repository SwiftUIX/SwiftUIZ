//
// Copyright (c) Vatsal Manot
//

import SwiftUI

public final class _ViewGraphScopeID: CustomStringConvertible, Hashable {
    @inlinable
    public var description: String {
        String(hashValue, radix: 36, uppercase: false)
    }
    
    public init() {
        
    }
    
    @inlinable
    public func hash(into hasher: inout Hasher) {
        hasher.combine(ObjectIdentifier(self))
    }
    
    @inlinable
    public static func == (lhs: _ViewGraphScopeID, rhs: _ViewGraphScopeID) -> Bool {
        lhs === rhs
    }
}

public struct _ViewAttributeID {
    private let key: AnyHashable
    private let type: ObjectIdentifier
    private let overrideScopeID: _ViewGraphScopeID?
    private let getName: () -> String
    
    public var isOverridden: Bool {
        overrideScopeID != nil
    }
    
    public init(
        key: AnyHashable,
        type: ObjectIdentifier,
        overrideScopeID: _ViewGraphScopeID?,
        getName: @escaping () -> String
    ) {
        self.key = key
        self.type = type
        self.overrideScopeID = overrideScopeID
        self.getName = getName
    }
}

// MARK: - Conformances

extension _ViewAttributeID: CustomStringConvertible {
    public var description: String {
        if let overrideScopeID {
            return getName() + "-override:\(overrideScopeID)"
        }
        else {
            return getName()
        }
    }
}

extension _ViewAttributeID: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(key)
        hasher.combine(type)
        hasher.combine(overrideScopeID)
    }
    
    public static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.key == rhs.key && lhs.type == rhs.type && lhs.overrideScopeID == rhs.overrideScopeID
    }
}
