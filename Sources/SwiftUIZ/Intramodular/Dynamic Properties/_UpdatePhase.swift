//
// Copyright (c) Vatsal Manot
//

import Combine
import SwiftUI

/// A property wrapper that automatically updates its value when the `View` it is attached to updates.
///
/// From [Engine](http://github.com/nathantannar4/Engine).
@propertyWrapper
@frozen
public struct _UpdatePhase: DynamicProperty {
    @frozen
    public struct Value: Hashable {
        @usableFromInline
        var phase: UInt32
        
        @inlinable
        public init() {
            self.phase = 0
        }
        
        mutating func update() {
            phase = phase &+ 1
        }
    }
    
    @usableFromInline
    var storage: StateObject<Storage>
    
    public var wrappedValue: Value {
        storage.wrappedValue.value
    }
    
    @inlinable
    public init() {
        self.storage = StateObject(wrappedValue: Storage(value: Value()))
    }
    
    public mutating func update() {
        storage.wrappedValue.value.update()
    }
}

// MARK: - Auxiliary

extension _UpdatePhase {
    @usableFromInline
    final class Storage: ObservableObject {
        var value: Value
        
        @usableFromInline
        init(value: Value) {
            self.value = value
        }
    }
}
