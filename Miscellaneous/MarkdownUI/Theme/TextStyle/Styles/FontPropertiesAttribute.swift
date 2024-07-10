//
// Copyright (c) Vatsal Manot
//

import Swallow
import SwiftUI

@frozen
@usableFromInline
enum FontPropertiesAttribute: AttributedStringKey {
    @usableFromInline
    typealias Value = FontProperties
    
    @usableFromInline
    static let name = "fontProperties"
}

extension AttributeScopes {
    var markdownUI: MarkdownUIAttributes.Type {
        MarkdownUIAttributes.self
    }
    
    @frozen
    @usableFromInline
    struct MarkdownUIAttributes: AttributeScope {
        let swiftUI: SwiftUIAttributes
        let fontProperties: FontPropertiesAttribute
    }
}

extension AttributeDynamicLookup {
    subscript<T: AttributedStringKey>(
        dynamicMember keyPath: KeyPath<AttributeScopes.MarkdownUIAttributes, T>
    ) -> T {
        @_transparent
        get {
            return self[T.self]
        }
    }
}

extension AttributedString {
    func resolvingFonts() -> AttributedString {
        _memoize(uniquingWith: self) {
            var output = self
            
            for run in output.runs {
                guard let fontProperties = run.fontProperties else {
                    continue
                }
                output[run.range].font = .withProperties(fontProperties)
                output[run.range].fontProperties = nil
            }
            
            return output
        }
    }
}
