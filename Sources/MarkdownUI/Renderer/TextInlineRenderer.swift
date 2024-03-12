//
// Copyright (c) Vatsal Manot
//

import SwiftUI

extension Sequence where Element == InlineNode {
    @_optimize(speed)
    @_transparent
    func renderText(
        baseURL: URL?,
        textStyles: InlineTextStyles,
        images: [String: Image],
        attributes: AttributeContainer
    ) -> Text {
        let renderer = TextInlineRenderer(
            baseURL: baseURL,
            textStyles: textStyles,
            images: images,
            attributes: attributes
        )
        
        renderer.render(self)
        
        return renderer.result
    }
}

@usableFromInline
final class TextInlineRenderer {
    var result = Text(verbatim: "")
    
    private let baseURL: URL?
    private let textStyles: InlineTextStyles
    private let images: [String: Image]
    private let attributes: AttributeContainer
    private var shouldSkipNextWhitespace = false
    
    @usableFromInline
    init(
        baseURL: URL?,
        textStyles: InlineTextStyles,
        images: [String: Image],
        attributes: AttributeContainer
    ) {
        self.baseURL = baseURL
        self.textStyles = textStyles
        self.images = images
        self.attributes = attributes
    }
    
    @inline(__always)
    func render<S: Sequence>(
        _ inlines: S
    ) where S.Element == InlineNode {
        for inline in inlines {
            self.render(inline)
        }
    }
    
    @_optimize(speed)
    func render(_ inline: InlineNode) {
        switch inline {
            case .text(let content):
                self.renderText(content)
            case .softBreak:
                self.renderSoftBreak()
            case .html(let content):
                self.renderHTML(content)
            case .image(let source, _):
                self.renderImage(source)
            default:
                self.defaultRender(inline)
        }
    }
    
    @_optimize(speed)
    @inline(__always)
    func renderText(_ text: String) {
        var text = text
        
        if self.shouldSkipNextWhitespace {
            self.shouldSkipNextWhitespace = false
            text = text.replacingOccurrences(of: "^\\s+", with: "", options: .regularExpression)
        }
        
        self.defaultRender(.text(text))
    }
    
    @_optimize(speed)
    @inline(__always)
    func renderSoftBreak() {
        if self.shouldSkipNextWhitespace {
            self.shouldSkipNextWhitespace = false
        } else {
            self.defaultRender(.softBreak)
        }
    }
    
    @_optimize(speed)
    @inline(__always)
    func renderHTML(_ html: String) {
        let tag = HTMLTag(html)
        
        switch tag?.name.lowercased() {
            case "br":
                self.defaultRender(.lineBreak)
                self.shouldSkipNextWhitespace = true
            default:
                self.defaultRender(.html(html))
        }
    }
    
    @_optimize(speed)
    @inline(__always)
    func renderImage(_ source: String) {
        if let image = self.images[source] {
            self.result = self.result + Text(image)
        }
    }
    
    @_optimize(speed)
    @inline(__always)
    func defaultRender(
        _ inline: InlineNode
    ) {
        self.result = self.result + Text(
            inline.renderAttributedString(
                baseURL: self.baseURL,
                textStyles: self.textStyles,
                attributes: self.attributes
            )
        )
    }
}
