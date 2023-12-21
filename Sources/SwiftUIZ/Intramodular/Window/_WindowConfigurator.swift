//
// Copyright (c) Vatsal Manot
//

import Swallow
import SwiftUIX

#if os(macOS)
struct _SwiftUIX_WindowConfiguration {
    let backgroundColor: Color?
}

@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
struct _WindowConfigurator: ViewModifier {
    let configuration: _SwiftUIX_WindowConfiguration
    
    @State private var window = Weak<NSWindow>()
    
    func body(content: Content) -> some View {
        fatalError()
    }
}
#endif

