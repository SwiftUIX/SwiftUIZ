//
// Copyright (c) Vatsal Manot
//

import SwiftUI

public struct _ViewAttributeID {
    private let key: AnyHashable
    private let type: ObjectIdentifier
    private let interposeScope: _ViewInterposeScope?
    private let getName: () -> String
    
    public var isOverridden: Bool {
        interposeScope != nil
    }
    
    public init(
        key: AnyHashable,
        type: ObjectIdentifier,
        interposeScope: _ViewInterposeScope?,
        getName: @escaping () -> String
    ) {
        self.key = key
        self.type = type
        self.interposeScope = interposeScope
        self.getName = getName
    }
}

// MARK: - Conformances

extension _ViewAttributeID: CustomStringConvertible {
    public var description: String {
        if let interposeScope {
            return getName() + "-override:\(interposeScope)"
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
        hasher.combine(interposeScope)
    }
    
    public static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.key == rhs.key && lhs.type == rhs.type && lhs.interposeScope == rhs.interposeScope
    }
}
