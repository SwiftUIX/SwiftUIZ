//
// Copyright (c) Vatsal Manot
//

import SwiftUI

public struct ViewThatMakesSense<Content: View>: View {
    public let content: Content
    
    public init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    
    public var body: some View {
        _UnimplementedView()
    }
}
