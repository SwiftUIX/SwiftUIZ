//
// Copyright (c) Vatsal Manot
//

@_implementationOnly import _SwiftUIZ_cmark_gfm
import Foundation

typealias UnsafeNode = UnsafeMutablePointer<cmark_node>

extension UnsafeNode {
    var nodeType: NodeType {
        let typeString = String(cString: cmark_node_get_type_string(self))
        
        guard let nodeType = NodeType(rawValue: typeString) else {
            fatalError("Unknown node type '\(typeString)' found.")
        }
        
        return nodeType
    }
    
    @_optimize(speed)
    var children: UnsafeNodeSequence {
        .init(cmark_node_first_child(self))
    }
    
    @_optimize(speed)
    var literal: String? {
        cmark_node_get_literal(self).map(String.init(cString:))
    }
    
    @_optimize(speed)
    var url: String? {
        cmark_node_get_url(self).map(String.init(cString:))
    }
    
    @_optimize(speed)
    var isTaskListItem: Bool {
        self.nodeType == .taskListItem
    }
    
    @_optimize(speed)
    var listType: cmark_list_type {
        cmark_node_get_list_type(self)
    }
    
    @_optimize(speed)
    var listStart: Int {
        Int(cmark_node_get_list_start(self))
    }
    
    @_optimize(speed)
    var isTaskListItemChecked: Bool {
        cmark_gfm_extensions_get_tasklist_item_checked(self)
    }
    
    @_optimize(speed)
    var isTightList: Bool {
        cmark_node_get_list_tight(self) != 0
    }
    
    @_optimize(speed)
    var fenceInfo: String? {
        cmark_node_get_fence_info(self).map(String.init(cString:))
    }
    
    @_optimize(speed)
    var headingLevel: Int {
        Int(cmark_node_get_heading_level(self))
    }
    
    @_optimize(speed)
    var tableColumns: Int {
        Int(cmark_gfm_extensions_get_table_columns(self))
    }
    
    @_optimize(speed)
    var tableAlignments: [RawTableColumnAlignment] {
        (0..<self.tableColumns).map { column in
            let ascii = cmark_gfm_extensions_get_table_alignments(self)[column]
            let scalar = UnicodeScalar(ascii)
            let character = Character(scalar)
            return .init(rawValue: character) ?? .none
        }
    }
    
    @_optimize(speed)
    static func parseMarkdown<ResultType>(
        _ markdown: String,
        body: (UnsafeNode) throws -> ResultType
    ) rethrows -> ResultType? {
        cmark_gfm_core_extensions_ensure_registered()
        
        // Create a Markdown parser and attach the GitHub syntax extensions
        
        let parser = cmark_parser_new(CMARK_OPT_DEFAULT)
        defer { cmark_parser_free(parser) }
        
        let extensionNames: Set<String>
        
        if #available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *) {
            extensionNames = ["autolink", "strikethrough", "tagfilter", "tasklist", "table"]
        } else {
            extensionNames = ["autolink", "strikethrough", "tagfilter", "tasklist"]
        }
        
        for extensionName in extensionNames {
            guard let syntaxExtension = cmark_find_syntax_extension(extensionName) else {
                continue
            }
            cmark_parser_attach_syntax_extension(parser, syntaxExtension)
        }
        
        // Parse the Markdown document
        
        cmark_parser_feed(parser, markdown, markdown.utf8.count)
        
        guard let document = cmark_parser_finish(parser) else {
            return nil
        }
        
        defer {
            //traverse(node: .init(node: document), source: markdown)
            
            cmark_node_free(document)
        }
        
        return try body(document)
    }
    
    static func makeDocument<ResultType>(
        _ blocks: [BlockNode],
        body: (UnsafeNode) throws -> ResultType
    ) rethrows -> ResultType? {
        cmark_gfm_core_extensions_ensure_registered()
        guard let document = cmark_node_new(CMARK_NODE_DOCUMENT) else { return nil }
        blocks.compactMap(UnsafeNode.make).forEach { cmark_node_append_child(document, $0) }
        
        defer { cmark_node_free(document) }
        return try body(document)
    }
    
    static func make(_ block: BlockNode) -> UnsafeNode? {
        switch block {
            case .blockquote(let children):
                guard let node = cmark_node_new(CMARK_NODE_BLOCK_QUOTE) else { return nil }
                children.compactMap(UnsafeNode.make).forEach { cmark_node_append_child(node, $0) }
                return node
            case .bulletedList(let isTight, let items):
                guard let node = cmark_node_new(CMARK_NODE_LIST) else { return nil }
                cmark_node_set_list_type(node, CMARK_BULLET_LIST)
                cmark_node_set_list_tight(node, isTight ? 1 : 0)
                items.compactMap(UnsafeNode.make).forEach { cmark_node_append_child(node, $0) }
                return node
            case .numberedList(let isTight, let start, let items):
                guard let node = cmark_node_new(CMARK_NODE_LIST) else { return nil }
                cmark_node_set_list_type(node, CMARK_ORDERED_LIST)
                cmark_node_set_list_tight(node, isTight ? 1 : 0)
                cmark_node_set_list_start(node, Int32(start))
                items.compactMap(UnsafeNode.make).forEach { cmark_node_append_child(node, $0) }
                return node
            case .taskList(let isTight, let items):
                guard let node = cmark_node_new(CMARK_NODE_LIST) else { return nil }
                cmark_node_set_list_type(node, CMARK_BULLET_LIST)
                cmark_node_set_list_tight(node, isTight ? 1 : 0)
                items.compactMap(UnsafeNode.make).forEach { cmark_node_append_child(node, $0) }
                return node
            case .codeBlock(let fenceInfo, let content):
                guard let node = cmark_node_new(CMARK_NODE_CODE_BLOCK) else { return nil }
                if let fenceInfo {
                    cmark_node_set_fence_info(node, fenceInfo)
                }
                cmark_node_set_literal(node, content)
                return node
            case .htmlBlock(let content):
                guard let node = cmark_node_new(CMARK_NODE_HTML_BLOCK) else { return nil }
                cmark_node_set_literal(node, content)
                return node
            case .paragraph(let content):
                guard let node = cmark_node_new(CMARK_NODE_PARAGRAPH) else { return nil }
                content.compactMap(UnsafeNode.make).forEach { cmark_node_append_child(node, $0) }
                return node
            case .heading(let level, let content):
                guard let node = cmark_node_new(CMARK_NODE_HEADING) else { return nil }
                cmark_node_set_heading_level(node, Int32(level))
                content.compactMap(UnsafeNode.make).forEach { cmark_node_append_child(node, $0) }
                return node
            case .table(let columnAlignments, let rows):
                guard let table = cmark_find_syntax_extension("table"),
                      let node = cmark_node_new_with_ext(CMARK_NODE_TABLE, table)
                else {
                    return nil
                }
                cmark_gfm_extensions_set_table_columns(node, UInt16(columnAlignments.count))
                var alignments = columnAlignments.map { $0.rawValue.asciiValue! }
                cmark_gfm_extensions_set_table_alignments(node, UInt16(columnAlignments.count), &alignments)
                rows.compactMap(UnsafeNode.make).forEach { cmark_node_append_child(node, $0) }
                if let header = cmark_node_first_child(node) {
                    cmark_gfm_extensions_set_table_row_is_header(header, 1)
                }
                return node
            case .thematicBreak:
                guard let node = cmark_node_new(CMARK_NODE_THEMATIC_BREAK) else { return nil }
                return node
        }
    }
    
    static func make(_ item: RawListItem) -> UnsafeNode? {
        guard let node = cmark_node_new(CMARK_NODE_ITEM) else { return nil }
        item.children.compactMap(UnsafeNode.make).forEach { cmark_node_append_child(node, $0) }
        return node
    }
    
    static func make(_ item: RawTaskListItem) -> UnsafeNode? {
        guard let tasklist = cmark_find_syntax_extension("tasklist"),
              let node = cmark_node_new_with_ext(CMARK_NODE_ITEM, tasklist)
        else {
            return nil
        }
        cmark_gfm_extensions_set_tasklist_item_checked(node, item.isCompleted)
        item.children.compactMap(UnsafeNode.make).forEach { cmark_node_append_child(node, $0) }
        return node
    }
    
    @_optimize(speed)
    static func make(
        _ tableRow: RawTableRow
    ) -> UnsafeNode? {
        guard let table = cmark_find_syntax_extension("table"),
              let node = cmark_node_new_with_ext(CMARK_NODE_TABLE_ROW, table)
        else {
            return nil
        }
        
        tableRow.cells.compactMap(UnsafeNode.make).forEach { cmark_node_append_child(node, $0) }
     
        return node
    }
    
    @_optimize(speed)
    static func make(
        _ tableCell: RawTableCell
    ) -> UnsafeNode? {
        guard let table = cmark_find_syntax_extension("table"),
              let node = cmark_node_new_with_ext(CMARK_NODE_TABLE_CELL, table)
        else {
            return nil
        }
        
        tableCell.content.compactMap(UnsafeNode.make).forEach {
            cmark_node_append_child(node, $0)
        }
        
        return node
    }
    
    static func make(_ inline: InlineNode) -> UnsafeNode? {
        switch inline {
            case .text(let content):
                guard let node = cmark_node_new(CMARK_NODE_TEXT) else { return nil }
                cmark_node_set_literal(node, content)
                return node
            case .softBreak:
                return cmark_node_new(CMARK_NODE_SOFTBREAK)
            case .lineBreak:
                return cmark_node_new(CMARK_NODE_LINEBREAK)
            case .code(let content):
                guard let node = cmark_node_new(CMARK_NODE_CODE) else { return nil }
                cmark_node_set_literal(node, content)
                return node
            case .html(let content):
                guard let node = cmark_node_new(CMARK_NODE_HTML_INLINE) else { return nil }
                cmark_node_set_literal(node, content)
                return node
            case .emphasis(let children):
                guard let node = cmark_node_new(CMARK_NODE_EMPH) else { return nil }
                children.compactMap(UnsafeNode.make).forEach { cmark_node_append_child(node, $0) }
                return node
            case .strong(let children):
                guard let node = cmark_node_new(CMARK_NODE_STRONG) else { return nil }
                children.compactMap(UnsafeNode.make).forEach { cmark_node_append_child(node, $0) }
                return node
            case .strikethrough(let children):
                guard let strikethrough = cmark_find_syntax_extension("strikethrough"),
                      let node = cmark_node_new_with_ext(CMARK_NODE_STRIKETHROUGH, strikethrough)
                else {
                    return nil
                }
                children.compactMap(UnsafeNode.make).forEach { cmark_node_append_child(node, $0) }
                return node
            case .link(let destination, let children):
                guard let node = cmark_node_new(CMARK_NODE_LINK) else { return nil }
                cmark_node_set_url(node, destination)
                children.compactMap(UnsafeNode.make).forEach { cmark_node_append_child(node, $0) }
                return node
            case .image(let source, let children):
                guard let node = cmark_node_new(CMARK_NODE_IMAGE) else { return nil }
                cmark_node_set_url(node, source)
                children.compactMap(UnsafeNode.make).forEach { cmark_node_append_child(node, $0) }
                return node
        }
    }
}

enum NodeType: String {
    case document
    case blockquote = "block_quote"
    case list
    case item
    case codeBlock = "code_block"
    case htmlBlock = "html_block"
    case customBlock = "custom_block"
    case paragraph
    case heading
    case thematicBreak = "thematic_break"
    case text
    case softBreak = "softbreak"
    case lineBreak = "linebreak"
    case code
    case html = "html_inline"
    case customInline = "custom_inline"
    case emphasis = "emph"
    case strong
    case link
    case image
    case inlineAttributes = "attribute"
    case none = "NONE"
    case unknown = "<unknown>"
    
    // Extensions
    
    case strikethrough
    case table
    case tableHead = "table_header"
    case tableRow = "table_row"
    case tableCell = "table_cell"
    case taskListItem = "tasklist"
}

struct UnsafeNodeSequence: Sequence {
    @frozen
    @usableFromInline
    struct Iterator: IteratorProtocol {
        var node: UnsafeNode?
        
        @_optimize(speed)
            init(_ node: UnsafeNode?) {
            self.node = node
        }
        
        @_optimize(speed)
            mutating func next() -> UnsafeNode? {
            guard let node else {
                return nil
            }
            
            defer {
                self.node = cmark_node_next(node)
            }
            
            return node
        }
    }
    
    @usableFromInline
    let node: UnsafeNode?
    
    @usableFromInline
    @_optimize(speed)
    init(_ node: UnsafeNode?) {
        self.node = node
    }
    
    func makeIterator() -> Iterator {
        Iterator(self.node)
    }
}

class CustomCMarkNode {
    var node: UnsafeMutablePointer<cmark_node> // The original cmark_node
    var utf16Range: Range<String.Index>?
    
    init(node: UnsafeMutablePointer<cmark_node>) {
        self.node = node
    }
}

extension UnsafeNode {
    @_optimize(speed)
    static func traverse(
        node customNode: CustomCMarkNode,
        source: String
    ) -> CustomCMarkNode {
        let node = customNode.node
        
        let startLine = cmark_node_get_start_line(node)
        let startColumn = cmark_node_get_start_column(node)
        let endLine = cmark_node_get_end_line(node)
        let endColumn = cmark_node_get_end_column(node)
        
        if let range = utf16Range(
            fromLine: Int(startLine),
            startColumn: Int(startColumn),
            endLine: Int(endLine),
            endColumn: Int(endColumn),
            in: source
        ) {
            Swift.print(source[range], "\n-------\n")
        }
        
        var child = cmark_node_first_child(node)
        while child != nil {
            let _ = traverse(node: .init(node: child!), source: source)
            child = cmark_node_next(child)
        }
        
        return customNode
    }
    
    @_optimize(speed)
    static func utf16Range(
        fromLine startLine: Int,
        startColumn: Int,
        endLine: Int,
        endColumn: Int,
        in source: String
    ) -> Range<String.Index>? {
        var currentLine = 1
        var currentColumn = 1
        var startIndex: String.Index?
        var endIndex: String.Index?
        
        var iterator = source.makeIterator()
        var currentIndex = source.startIndex
        
        while let char = iterator.next() {
            if currentLine == startLine && currentColumn == startColumn {
                startIndex = currentIndex
            }
            
            if currentLine == endLine && currentColumn == endColumn {
                endIndex = source.index(after: currentIndex)
                break
            }
            
            currentIndex = source.index(after: currentIndex)
            
            if char == "\n" {
                currentLine += 1
                currentColumn = 1
            } else {
                currentColumn += 1
            }
        }
        
        if let start = startIndex, let end = endIndex {
            return start..<end
        }
        
        return nil
    }
}
