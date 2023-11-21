//
// Copyright (c) Vatsal Manot
//

import SwiftUIX

public struct _BufferedBinding<Value: Equatable, Content: View>: View {
    public let value: Binding<Value>
    
    @State private var valueCopy: Value
    
    public let content: (Binding<Value>) -> Content
    
    public init(
        over value: Binding<Value>,
        @ViewBuilder content: @escaping (Binding<Value>) -> Content
    ) {
        self.value = value
        self._valueCopy = .init(initialValue: value.wrappedValue)
        self.content = content
    }
    
    public var body: some View {
        content($valueCopy.onSet { newValue in
            value.wrappedValue = newValue
        })
    }
}
