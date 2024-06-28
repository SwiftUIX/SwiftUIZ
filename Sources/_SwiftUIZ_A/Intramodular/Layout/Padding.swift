//
// Copyright (c) Vatsal Manot
//

import SwiftUIX

public struct Padding: View {
    public var body: some View {
        ZeroSizeView()
            .padding(.extraSmall)
            .modifier(_StipAllListItemStyling(insetsIncluded: false))
            .accessibilityHidden(true)
            .opacity(0)
    }
    
    public init() {
        
    }
}
