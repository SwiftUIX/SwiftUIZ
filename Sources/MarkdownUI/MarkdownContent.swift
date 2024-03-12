import Foundation

/// A protocol that represents any Markdown content.
public protocol MarkdownContentProtocol {
    var _markdownContent: MarkdownContent { get }
}

public struct MarkdownContent: Hashable, MarkdownContentProtocol {
    let blocks: [BlockNode]
    
    public var _markdownContent: MarkdownContent {
        self
    }
    
    init(blocks: [BlockNode] = []) {
        self.blocks = blocks
    }
    
    init(block: BlockNode) {
        self.init(blocks: [block])
    }
    
    init(_ components: [MarkdownContentProtocol]) {
        self.init(blocks: components.map(\._markdownContent).flatMap(\.blocks))
    }
    
    /// Creates a Markdown content value from a Markdown-formatted string.
    /// - Parameter markdown: A Markdown-formatted string.
    public init(_ markdown: String) {
        self.init(blocks: Array<BlockNode>(markdown: markdown))
    }
}

extension MarkdownContent {
    /// Returns a Markdown content value with the sum of the contents of all the container blocks
    /// present in this content.
    ///
    /// You can use this property to access the contents of a blockquote or a list. Returns `nil` if
    /// there are no container blocks.
    public var childContent: MarkdownContent? {
        let children = self.blocks.map(\.children).flatMap { $0 }
        return children.isEmpty ? nil : .init(blocks: children)
    }

    /// Renders this Markdown content value as a Markdown-formatted text.
    public func renderMarkdown() -> String {
        let result = self.blocks.renderMarkdown()
        
        return result.hasSuffix("\n") ? String(result.dropLast()) : result
    }
    
    /// Renders this Markdown content value as plain text.
    public func renderPlainText() -> String {
        let result = self.blocks.renderPlainText()
        
        return result.hasSuffix("\n") ? String(result.dropLast()) : result
    }
}
