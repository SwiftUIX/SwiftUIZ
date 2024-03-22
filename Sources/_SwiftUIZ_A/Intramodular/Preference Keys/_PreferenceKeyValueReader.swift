//
// Copyright (c) Vatsal Manot
//

import SwiftUI

@_spi(Internal)
@frozen
public struct _PreferenceKeyValueProxy<Key: PreferenceKey> {
    let base: _PreferenceValue<Key>
}

@_spi(Internal)
@frozen
public struct _PreferenceKeyReader<Key: PreferenceKey, Content: View>: View {
    @usableFromInline
    let content: (_PreferenceKeyValueProxy<Key>) -> Content
    
    @inlinable
    public init(
        _ key: Key.Type,
        @ViewBuilder content: @escaping (_PreferenceKeyValueProxy<Key>) -> Content
    ) {
        self.content = content
    }
    
    public var body: some View {
        Key._delay { value in
            content(_PreferenceKeyValueProxy(base: value))
        }
    }
}

@_spi(Internal)
@frozen
public struct _PreferenceKeyValueReader<Key: PreferenceKey, Content: View>: View {
    @usableFromInline
    let value: _PreferenceKeyValueProxy<Key>
    @usableFromInline
    let content: (Key.Value) -> Content
    
    @inlinable
    public init(
        _ value: _PreferenceKeyValueProxy<Key>,
        @ViewBuilder content: @escaping (Key.Value) -> Content
    ) {
        self.value = value
        self.content = content
    }
    
    public var body: some View {
        _PreferenceReadingView(value: value.base) { value in
            content(value)
        }
    }
}
