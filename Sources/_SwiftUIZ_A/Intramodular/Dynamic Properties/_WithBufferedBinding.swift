//
// Copyright (c) Vatsal Manot
//

import SwiftUIX

fileprivate struct _WithBufferedBinding<Value: Equatable, Content: View>: View {
    let value: Binding<Value>
    let toDestinationOnly: Bool
    
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
        toDestinationOnly: Bool = false,
        @ViewBuilder content: @escaping (Binding<Value>) -> Content
    ) {
        self.value = value
        self.toDestinationOnly = toDestinationOnly
        self._valueCopy = .init(initialValue: value.wrappedValue)
        self.content = content
    }
    
    var body: some View {
        content(valueBinding)
            .background {
                if !toDestinationOnly {
                    ZeroSizeView().withChangePublisher(for: self.value.wrappedValue) { publisher in
                        publisher
                            .debounce(for: .milliseconds(50), scheduler: DispatchQueue.main)
                            .sink {
                                self.valueBinding.wrappedValue = $0
                            }
                    }
                }
            }
    }
}

public func _withBufferedBinding<Value: Equatable, Content: View>(
    over binding: Binding<Value>,
    toDestinationOnly: Bool = false,
    content: @escaping (Binding<Value>) -> Content
) -> some View {
    _WithBufferedBinding(over: binding, toDestinationOnly: toDestinationOnly, content: content)
}
