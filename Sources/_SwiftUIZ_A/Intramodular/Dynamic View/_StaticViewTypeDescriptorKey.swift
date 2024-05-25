//
// Copyright (c) Vatsal Manot
//

import Swallow
import SwiftUI

public protocol _StaticViewTypeDescriptorKey<Value>: HeterogeneousDictionaryKey where Self.Domain == _StaticViewTypeDescriptor {
    static var defaultValue: Value { get }
}

extension _StaticViewTypeDescriptor {
    public protocol StaticUpdater {
        static func update(
            _ descriptor: inout _StaticViewTypeDescriptor,
            context: _StaticViewTypeDescriptor.UpdateContext
        ) throws
    }
}

// MARK: - Implementation

extension _StaticViewTypeDescriptorKey where Value: Initiable {
    package static var defaultValue: Value {
        Value()
    }
}

extension _GenericHeterogeneousDictionaryKey: _StaticViewTypeDescriptorKey where Self.Domain == _StaticViewTypeDescriptor, Self.Value: Initiable {
    public static var defaultValue: Value {
        Value()
    }
}
