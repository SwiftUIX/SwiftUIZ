//
// Copyright (c) Vatsal Manot
//

import Merge
import Swallow
import SwiftUI

public protocol _SwiftUIZ_BindingType<Value> {
    associatedtype Value
    
    var wrappedValue: Value { get nonmutating set }
    
    subscript<Subject>(
        _dynamicMember keyPath: WritableKeyPath<Value, Subject>
    ) -> any _SwiftUIZ_BindingType<Subject> { get }
}

// MARK: - Supplementary

extension Binding {
    @_spi(Internal)
    public init(_from binding: some _SwiftUIZ_BindingType<Value>) {
        self.init(
            get: {
                binding.wrappedValue
            },
            set: { 
                binding.wrappedValue = $0
            }
        )
    }
}

// MARK: - Implemented Conformances

extension Merge.PublishedAsyncBinding: _SwiftUIZ_BindingType {
    @_disfavoredOverload
    public subscript<Subject>(
        _dynamicMember keyPath: WritableKeyPath<Value, Subject>
    ) -> any _SwiftUIZ_BindingType<Subject> {
        self[dynamicMember: keyPath]
    }
}

extension Merge.PublishedBinding: _SwiftUIZ_BindingType {
    @_disfavoredOverload
    public subscript<Subject>(
        _dynamicMember keyPath: WritableKeyPath<Value, Subject>
    ) -> any _SwiftUIZ_BindingType<Subject> {
        self[dynamicMember: keyPath]
    }
}

extension Swallow.Inout: _SwiftUIZ_BindingType {
    @_disfavoredOverload
    public subscript<Subject>(
        _dynamicMember keyPath: WritableKeyPath<Value, Subject>
    ) -> any _SwiftUIZ_BindingType<Subject> {
        self[dynamicMember: keyPath]
    }
}

extension SwiftUI.Binding: _SwiftUIZ_BindingType {
    @_disfavoredOverload
    public subscript<Subject>(
        _dynamicMember keyPath: WritableKeyPath<Value, Subject>
    ) -> any _SwiftUIZ_BindingType<Subject> {
        self[dynamicMember: keyPath]
    }
}
