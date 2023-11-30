//
// Copyright (c) Vatsal Manot
//

import Swallow
import SwiftUI

public protocol _HasPreferenceKey {
    associatedtype _PreferenceKey: SwiftUI.PreferenceKey
}

extension MergeOperatable where Self: _HasPreferenceKey {
    public typealias _PreferenceKey = _MergeOperatableOptionalTypeToPreferenceKeyAdaptor<Self>
}

extension MergeOperatable where Self: _HasPreferenceKey & Initiable  {
    public typealias _PreferenceKey = _InitiableMergeOperatableTypeToPreferenceKeyAdaptor<Self>
}

// MARK: - Supplementary

extension View {
    public func preference<T: _HasPreferenceKey>(
        _ value: T
    ) -> some View where T._PreferenceKey.Value == T {
        preference(key: T._PreferenceKey.self, value: value)
    }
    
    public func preference<T: _HasPreferenceKey>(
        _ value: T
    ) -> some View where T._PreferenceKey.Value == Optional<T> {
        preference(key: T._PreferenceKey.self, value: Optional<T>.some(value))
    }
}

// MARK: - Auxiliary

public struct _TypeToOptionalPreferenceKeyAdaptor<T: _HasPreferenceKey>: PreferenceKey {
    public typealias Value = T?
    
    public static func reduce(
        value: inout T?,
        nextValue: () -> T?
    ) {
        value = nextValue() ?? value
    }
}

public struct _MergeOperatableOptionalTypeToPreferenceKeyAdaptor<T: _HasPreferenceKey & MergeOperatable>: PreferenceKey {
    public typealias Value = T?
    
    public static func reduce(
        value: inout T?,
        nextValue: () -> T?
    ) {
        if value != nil {
            guard let nextValue = nextValue() else {
                return
            }
            
            value?.mergeInPlace(with: nextValue)
        } else {
            value = nextValue() ?? value
        }
    }
}

public struct _InitiableMergeOperatableTypeToPreferenceKeyAdaptor<T: _HasPreferenceKey & Initiable & MergeOperatable>: PreferenceKey {
    public typealias Value = T
    
    public static var defaultValue: T {
        T.init()
    }
    
    public static func reduce(
        value: inout T,
        nextValue: () -> T
    ) {
        value.mergeInPlace(with: nextValue())
    }
}
