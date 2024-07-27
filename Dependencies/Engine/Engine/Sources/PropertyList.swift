//
// Copyright (c) Nathan Tannar
//

import SwiftUI

public struct PropertyList {
    public struct ElementLayout<Fields>: CustomStringConvertible {
        var metadata: (Any.Type, UInt)
        var fields: Fields
        
        public var description: String {
            String(describing: fields)
        }
        
        mutating func withUnsafeValuePointer<T, ReturnType>(
            _ type: T.Type,
            do body: (UnsafeMutablePointer<PropertyList.TypedElementLayout<Fields, T>>) -> ReturnType
        ) -> ReturnType {
            withUnsafeMutablePointer(to: &self) { ptr -> ReturnType in
                ptr.withMemoryRebound(
                    to: PropertyList.TypedElementLayout<Fields, T>.self,
                    capacity: 1,
                    body
                )
            }
        }
    }
    
    public struct ElementFieldsV1: CustomReflectable, CustomStringConvertible {
        var keyType: Any.Type
        var before: UnsafeMutablePointer<ElementLayout<ElementFieldsV1>>?
        var after: UnsafeMutablePointer<ElementLayout<ElementFieldsV1>>?
        var length: Int
        var keyFilter: UInt
        var id: Int
        
        public var description: String {
            String(describing: keyType)
        }
        
        public var customMirror: Mirror {
            Mirror(self, children: [
                "keyType": keyType,
                "length": length,
                "keyFilter": keyFilter,
                "id": id,
            ])
        }
    }
    
    public struct ElementFieldsV6: CustomReflectable, CustomStringConvertible {
        var keyType: Any.Type
        var before: UnsafeMutablePointer<ElementLayout<ElementFieldsV6>>?
        var after: UnsafeMutablePointer<ElementLayout<ElementFieldsV6>>?
        var skip: UnsafeMutablePointer<ElementLayout<ElementFieldsV6>>?
        var length: UInt32
        var skipCount: UInt32
        var keyFilter: UInt
        var id: Int
        
        public var description: String {
            String(describing: keyType)
        }
        
        public var customMirror: Mirror {
            Mirror(self, children: [
                "keyType": keyType,
                "length": length,
                "keyFilter": keyFilter,
                "id": id,
            ])
        }
    }
    
    public struct TypedElementLayout<Fields, Value> {
        var base: ElementLayout<Fields>
        var value: Value
    }
    
    public enum ElementPointer: CustomReflectable, CustomStringConvertible {
        case v1(UnsafeMutablePointer<ElementLayout<ElementFieldsV1>>)
        case v6(UnsafeMutablePointer<ElementLayout<ElementFieldsV6>>)
        
        public var description: String {
            switch self {
                case .v1(let pointer):
                    String(describing: pointer.pointee)
                case .v6(let pointer):
                    String(describing: pointer.pointee)
            }
        }
        
        public var customMirror: Mirror {
            Mirror(self, children: [
                "object": object,
                "metadata": metadata,
                "fields": fields,
                "keyType": keyType,
            ])
        }
        
        var object: Unmanaged<AnyObject> {
            switch self {
                case .v1(let ptr): Unmanaged<AnyObject>.fromOpaque(ptr)
                case .v6(let ptr): Unmanaged<AnyObject>.fromOpaque(ptr)
            }
        }
        
        var metadata: (Any.Type, UInt) {
            switch self {
                case .v1(let ptr): ptr.pointee.metadata
                case .v6(let ptr): ptr.pointee.metadata
            }
        }
        
        var fields: Any {
            switch self {
                case .v1(let ptr): ptr.pointee.fields
                case .v6(let ptr): ptr.pointee.fields
            }
        }
        
        var keyType: Any.Type {
            switch self {
                case .v1(let ptr): ptr.pointee.fields.keyType
                case .v6(let ptr): ptr.pointee.fields.keyType
            }
        }
        
        var after: ElementPointer? {
            get {
                switch self {
                    case .v1(let ptr):
                        guard let after = ptr.pointee.fields.after else { return nil }
                        return .v1(after)
                    case .v6(let ptr):
                        guard let after = ptr.pointee.fields.after else { return nil }
                        return .v6(after)
                }
            }
            nonmutating set {
                switch self {
                    case .v1(let ptr):
                        if case .v1(let newValue) = newValue {
                            ptr.pointee.fields.after = newValue
                        } else {
                            ptr.pointee.fields.after = nil
                        }
                    case .v6(let ptr):
                        if case .v6(let newValue) = newValue {
                            ptr.pointee.fields.after = newValue
                        } else {
                            ptr.pointee.fields.after = nil
                        }
                }
            }
        }
        
        var length: UInt32 {
            get {
                switch self {
                    case .v1(let ptr): UInt32(ptr.pointee.fields.length)
                    case .v6(let ptr): ptr.pointee.fields.length
                }
            }
            nonmutating set {
                switch self {
                    case .v1(let ptr):
                        ptr.pointee.fields.length = Int(newValue)
                    case .v6(let ptr):
                        ptr.pointee.fields.length = newValue
                }
            }
        }
        
        func getValue<T>(
            _ type: T.Type
        ) -> T {
            switch self {
                case .v1(let ptr):
                    return ptr.pointee.withUnsafeValuePointer(T.self) { ptr in
                        return ptr.pointee.value
                    }
                case .v6(let ptr):
                    return ptr.pointee.withUnsafeValuePointer(T.self) { ptr in
                        ptr.pointee.value
                    }
            }
        }
    }
    
    var ptr: UnsafeMutableRawPointer?
    
    var elements: ElementPointer? {
        guard let ptr else { return nil }
        if #available(iOS 18.0, macOS 15.0, tvOS 18.0, watchOS 11.0, visionOS 2.0, *) {
            return .v6(
                ptr.assumingMemoryBound(to: ElementLayout<ElementFieldsV6>.self)
            )
        } else {
            return .v1(
                ptr.assumingMemoryBound(to: ElementLayout<ElementFieldsV1>.self)
            )
        }
    }
    
    func value<Input, Value>(
        _ : Input.Type,
        as: Value.Type
    ) -> Value? {
        var ptr = elements
        while let p = ptr {
            if p.keyType == Input.self {
                return p.getValue(Value.self)
            }
            ptr = p.after
        }
        return nil
    }
    
    func value<Value>(
        key: String,
        as: Value.Type
    ) -> Value? {
        var ptr = elements
        while let p = ptr {
            let typeName = _typeName(p.keyType, qualified: false)
            if typeName == key {
                return p.getValue(Value.self)
            }
            ptr = p.after
        }
        return nil
    }
    
    mutating func add<Input, Value>(
        _ input: Input.Type,
        _ newValue: Value
    ) {
        guard let lastValue = ptr else {
            return
        }
        if #available(iOS 18.0, macOS 15.0, tvOS 18.0, watchOS 11.0, visionOS 2.0, *) {
            let lastValue = lastValue.assumingMemoryBound(to: ElementLayout<ElementFieldsV6>.self)
            let newValue = TypedElementLayout<ElementFieldsV6, Value>(
                base: ElementLayout(
                    metadata: lastValue.pointee.metadata,
                    fields: ElementFieldsV6(
                        keyType: Input.self,
                        before: nil,
                        after: lastValue,
                        skip: lastValue.pointee.fields.skip,
                        length: lastValue.pointee.fields.length + 1,
                        skipCount: lastValue.pointee.fields.skip != nil ? lastValue.pointee.fields.skipCount + 1 : 0,
                        keyFilter: lastValue.pointee.fields.keyFilter, // Unknown purpose
                        id: UniqueID.generate()
                    )
                ),
                value: newValue
            )
            let ref = UnsafeMutablePointer<TypedElementLayout<ElementFieldsV6, Value>>.allocate(capacity: 1)
            ref.initialize(to: newValue)
            ptr = UnsafeMutableRawPointer(ref)
        } else {
            let lastValue = lastValue.assumingMemoryBound(to: ElementLayout<ElementFieldsV1>.self)
            let newValue = TypedElementLayout<ElementFieldsV1, Value>(
                base: ElementLayout(
                    metadata: lastValue.pointee.metadata,
                    fields: ElementFieldsV1(
                        keyType: Input.self,
                        before: nil,
                        after: lastValue,
                        length: lastValue.pointee.fields.length + 1,
                        keyFilter: lastValue.pointee.fields.keyFilter, // Unknown purpose
                        id: UniqueID.generate()
                    )
                ),
                value: newValue
            )
            let ref = UnsafeMutablePointer<TypedElementLayout<ElementFieldsV1, Value>>.allocate(capacity: 1)
            ref.initialize(to: newValue)
            ptr = UnsafeMutableRawPointer(ref)
        }
    }
}

extension PropertyList: CustomDebugStringConvertible, CustomStringConvertible {
    public var debugDescription: String {
        description
    }
    
    public var description: String {
        Array(self).description
    }
}

extension PropertyList: Sequence {
    public func makeIterator() -> AnyIterator<ElementPointer> {
        guard let elements else {
            return AnyIterator(EmptyCollection<ElementPointer>().makeIterator())
        }
        
        
        return AnyIterator(
            sequence(first: elements, next: {
                $0.after
            })
            .makeIterator()
        )
    }
}

private struct UniqueID {
    private static var seed: Int = .max
    
    static func generate() -> Int {
        defer {
            seed -= 1
            if seed < 0 {
                seed = .max
            }
        }
        return seed
    }
}
