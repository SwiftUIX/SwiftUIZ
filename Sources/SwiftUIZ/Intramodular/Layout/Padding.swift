//
// Copyright (c) Vatsal Manot
//

import SwiftUIX

public struct Padding: View {
    public var body: some View {
        ZeroSizeView()
            .padding(.extraSmall)
            ._noListItemModification()
            .accessibilityHidden(true)
            .opacity(0)
    }
    
    public init() {
        
    }
}
