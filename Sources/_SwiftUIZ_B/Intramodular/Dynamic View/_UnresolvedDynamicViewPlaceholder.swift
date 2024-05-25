//
// Copyright (c) Vatsal Manot
//

import SwiftUIX

package struct _UnresolvedDynamicViewPlaceholder: View {
    let proxy: _DynamicViewProxy?
    
    package var body: some View {
        ZeroSizeView()
            .overlay {
                Text("Failed to resolve view!\n(com.vmanot.SwiftUIZ)")
                    .fixedSize()
                    .border(Color.red)
            }
    }
}
