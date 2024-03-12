//
// Copyright (c) Vatsal Manot
//

import Foundation

extension InlineNode {
    @_optimize(speed)
    @_transparent
    func renderAttributedString(
        baseURL: URL?,
        textStyles: InlineTextStyles,
        attributes: AttributeContainer
    ) -> AttributedString {
        let renderer = AttributedStringInlineRenderer(
            baseURL: baseURL,
            textStyles: textStyles,
            attributes: attributes
        )
        
        renderer.render(self)
        
        return renderer.result.resolvingFonts()
    }
}

@usableFromInline
final class AttributedStringInlineRenderer {
    var result = AttributedString()
    
    @usableFromInline
    let baseURL: URL?
    @usableFromInline
    let textStyles: InlineTextStyles
    @usableFromInline
    var attributes: AttributeContainer
    @usableFromInline
    var shouldSkipNextWhitespace = false
    
    @usableFromInline
    init(
        baseURL: URL?,
        textStyles: InlineTextStyles,
        attributes: AttributeContainer
    ) {
        self.baseURL = baseURL
        self.textStyles = textStyles
        self.attributes = attributes
    }
    
    @_optimize(speed)
    func render(_ inline: InlineNode) {
        switch inline {
            case .text(let content):
                self.renderText(content)
            case .softBreak:
                self.renderSoftBreak()
            case .lineBreak:
                self.renderLineBreak()
            case .code(let content):
                self.renderCode(content)
            case .html(let content):
                self.renderHTML(content)
            case .emphasis(let children):
                self.renderEmphasis(children: children)
            case .strong(let children):
                self.renderStrong(children: children)
            case .strikethrough(let children):
                self.renderStrikethrough(children: children)
            case .link(let destination, let children):
                self.renderLink(destination: destination, children: children)
            case .image(let source, let children):
                self.renderImage(source: source, children: children)
        }
    }
    
    @_optimize(speed)
    func renderText(
        _ text: String
    ) {
        var text = text
        
        if self.shouldSkipNextWhitespace {
            self.shouldSkipNextWhitespace = false
            
            text = text.replacingOccurrences(of: "^\\s+", with: "", options: .regularExpression)
        }
        
        self.result += AttributedString(text, attributes: self.attributes)
    }
    
    @_optimize(speed)
    func renderSoftBreak() {
        if self.shouldSkipNextWhitespace {
            self.shouldSkipNextWhitespace = false
        } else {
            self.result += AttributedString(" ", attributes: self.attributes)
        }
    }
    
    @_optimize(speed)
    func renderLineBreak() {
        self.result += AttributedString("\n", attributes: self.attributes)
    }
    
    @_optimize(speed)
    func renderCode(_ code: String) {
        self.result += AttributedString(code, attributes: self.textStyles.code.mergingAttributes(self.attributes))
    }
    
    @_optimize(speed)
    func renderHTML(_ html: String) {
        let tag = HTMLTag(html)
        
        switch tag?.name.lowercased() {
            case "br":
                self.renderLineBreak()
                self.shouldSkipNextWhitespace = true
            default:
                self.renderText(html)
        }
    }
    
    @_optimize(speed)
    func renderEmphasis(children: [InlineNode]) {
        let savedAttributes = self.attributes
        self.attributes = self.textStyles.emphasis.mergingAttributes(self.attributes)
        
        for child in children {
            self.render(child)
        }
        
        self.attributes = savedAttributes
    }
    
    @_optimize(speed)
    func renderStrong(children: [InlineNode]) {
        let savedAttributes = self.attributes
        self.attributes = self.textStyles.strong.mergingAttributes(self.attributes)
        
        for child in children {
            self.render(child)
        }
        
        self.attributes = savedAttributes
    }
    
    @_optimize(speed)
    func renderStrikethrough(children: [InlineNode]) {
        let savedAttributes = self.attributes
        self.attributes = self.textStyles.strikethrough.mergingAttributes(self.attributes)
        
        for child in children {
            self.render(child)
        }
        
        self.attributes = savedAttributes
    }
    
    @_optimize(speed)
    func renderLink(destination: String, children: [InlineNode]) {
        let savedAttributes = self.attributes
        self.attributes = self.textStyles.link.mergingAttributes(self.attributes)
        self.attributes.link = URL(string: destination, relativeTo: self.baseURL)
        
        for child in children {
            self.render(child)
        }
        
        self.attributes = savedAttributes
    }
    
    func renderImage(source: String, children: [InlineNode]) {
        assertionFailure()
        // AttributedString does not support images
    }
}

extension TextStyle {
    @_optimize(speed)
    @_transparent
    func mergingAttributes(
        _ attributes: AttributeContainer
    ) -> AttributeContainer {
        var newAttributes = attributes
        
        self._collectAttributes(in: &newAttributes)
        
        return newAttributes
    }
}
