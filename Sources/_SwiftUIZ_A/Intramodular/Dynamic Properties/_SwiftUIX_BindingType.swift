//
// Copyright (c) Vatsal Manot
//

import Merge
import Swallow
import SwiftUI

public protocol _SwiftUIX_BindingType<Value>: _SwiftUIZ_DynamicProperty {
    associatedtype Value
    
    var wrappedValue: Value { get nonmutating set }
    
    subscript<Subject>(
        _dynamicMember keyPath: WritableKeyPath<Value, Subject>
    ) -> any _SwiftUIX_BindingType<Subject> { get }
}

// MARK: - Supplementary

extension Binding {
    public init(_from binding: some _SwiftUIX_BindingType<Value>) {
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

// MARK: - Conformees

extension Merge.PublishedAsyncBinding: _SwiftUIZ_A._SwiftUIX_BindingType {
    @_disfavoredOverload
    public subscript<Subject>(
        _dynamicMember keyPath: WritableKeyPath<Value, Subject>
    ) -> any _SwiftUIX_BindingType<Subject> {
        self[dynamicMember: keyPath]
    }
}

extension Merge.PublishedBinding: _SwiftUIZ_A._SwiftUIX_BindingType {
    @_disfavoredOverload
    public subscript<Subject>(
        _dynamicMember keyPath: WritableKeyPath<Value, Subject>
    ) -> any _SwiftUIX_BindingType<Subject> {
        self[dynamicMember: keyPath]
    }
}

extension Swallow.Inout: _SwiftUIZ_A._SwiftUIX_BindingType {
    @_disfavoredOverload
    public subscript<Subject>(
        _dynamicMember keyPath: WritableKeyPath<Value, Subject>
    ) -> any _SwiftUIX_BindingType<Subject> {
        self[dynamicMember: keyPath]
    }
}

extension SwiftUI.Binding: _SwiftUIZ_A._SwiftUIX_BindingType {
    @_disfavoredOverload
    public subscript<Subject>(
        _dynamicMember keyPath: WritableKeyPath<Value, Subject>
    ) -> any _SwiftUIX_BindingType<Subject> {
        self[dynamicMember: keyPath]
    }
}
