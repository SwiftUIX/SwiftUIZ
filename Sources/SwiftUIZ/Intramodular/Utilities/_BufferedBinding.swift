//
// Copyright (c) Vatsal Manot
//

import SwiftUIX

fileprivate struct _WithBufferedBinding<Value: Equatable, Content: View>: View {
    let value: Binding<Value>
    
    @State private var valueCopy: Value
    
    let content: (Binding<Value>) -> Content
    
    var valueBinding: Binding<Value> {
        Binding(
            get: {
                valueCopy
            },
            set: { newValue in
                valueCopy = newValue
                value.wrappedValue = newValue
            }
        )
    }
    init(
        over value: Binding<Value>,
        @ViewBuilder content: @escaping (Binding<Value>) -> Content
    ) {
        self.value = value
        self._valueCopy = .init(initialValue: value.wrappedValue)
        self.content = content
    }
    
    var body: some View {
        content(valueBinding)
            .withChangePublisher(for: self.value.wrappedValue) { publisher in
                publisher
                    .debounce(for: .milliseconds(50), scheduler: DispatchQueue.main)
                    .sink {
                        self.valueBinding.wrappedValue = $0
                    }
            }
    }
}

public func withBufferedBinding<Value: Equatable, Content: View>(
    over binding: Binding<Value>,
    content: @escaping (Binding<Value>) -> Content
) -> some View {
    _WithBufferedBinding(over: binding, content: content)
}
