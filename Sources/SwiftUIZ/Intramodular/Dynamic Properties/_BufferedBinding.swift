//
// Copyright (c) Vatsal Manot
//

import SwiftUIX

fileprivate struct _WithBufferedBinding<Value: Equatable, Content: View>: View {
    let value: Binding<Value>
    
    @State private var valueCopy: Value
    
    let content: (Binding<Value>) -> Content
    
    init(
        over value: Binding<Value>,
        @ViewBuilder content: @escaping (Binding<Value>) -> Content
    ) {
        self.value = value
        self._valueCopy = .init(initialValue: value.wrappedValue)
        self.content = content
    }
    
    var body: some View {
        content($valueCopy.onSet { newValue in
            value.wrappedValue = newValue
        })
    }
}

public func withBufferedBinding<Value: Equatable, Content: View>(
    over binding: Binding<Value>,
    content: @escaping (Binding<Value>) -> Content
) -> some View {
    _WithBufferedBinding(over: binding, content: content)
}
