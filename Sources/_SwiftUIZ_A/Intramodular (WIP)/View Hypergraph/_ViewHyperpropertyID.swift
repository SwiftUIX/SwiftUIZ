//
// Copyright (c) Vatsal Manot
//

import Swallow
import SwiftUI

public struct _PGElementID: Hashable {
    private let localKey: AnyHashable
    private let swiftType: ObjectIdentifier
    private let interposeScope: _ViewInterposeScope?
    @HashIgnored
    private var name: () -> String
    
    public var isOverridden: Bool {
        interposeScope != nil
    }
    
    public init(
        localKey: AnyHashable,
        swiftType: ObjectIdentifier,
        interposeScope: _ViewInterposeScope?,
        name: @escaping () -> String
    ) {
        self.localKey = localKey
        self.swiftType = swiftType
        self.interposeScope = interposeScope
        self.name = name
    }
}

// MARK: - Conformances

extension _PGElementID: CustomStringConvertible {
    public var description: String {
        if let interposeScope {
            return name() + "-override:\(interposeScope)"
        } else {
            return name()
        }
    }
}
