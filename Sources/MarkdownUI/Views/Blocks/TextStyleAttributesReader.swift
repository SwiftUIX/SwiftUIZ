//
// Copyright (c) Vatsal Manot
//

import SwiftUIX

struct TextStyleAttributesReader<Content: View>: View {
    @Environment(\.textStyle) private var textStyle
    
    private let content: (AttributeContainer) -> Content
    
    @ViewStorage
    private var _cachedAttributes: AttributeContainer?
    
    private var attributes: AttributeContainer {
        if let _cachedAttributes {
            return _cachedAttributes
        }
        
        var result = AttributeContainer()
        
        self.textStyle._collectAttributes(in: &result)
        
        self._cachedAttributes = result
        
        return result
    }
    
    init(
        @ViewBuilder content: @escaping (_ attributes: AttributeContainer) -> Content
    ) {
        self.content = content
    }
    
    var body: some View {
        self.content(self.attributes)._onChange(of: textStyle.eraseToAnyEquatable()) { _ in
            self._cachedAttributes = nil
        }
    }
}
