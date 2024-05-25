//
// Copyright (c) Vatsal Manot
//

@_spi(Internal) private import SwiftUIX
import Foundation

@_implementationOnly import cmark_gfm

extension Array where Element == BlockNode {
    @_optimize(speed)
    @_transparent
    init(markdown: String) {
        let blocks = UnsafeNode.parseMarkdown(markdown) { document in
            document.children.compactMap(BlockNode.init(unsafeNode:))
        }
        
        self = Self(blocks ?? .init())
    }
    
    @_optimize(speed)
    @_transparent
    func renderMarkdown() -> String {
        UnsafeNode.makeDocument(self) { document in
            String(cString: cmark_render_commonmark(document, CMARK_OPT_DEFAULT, 0))
        } ?? ""
    }
    
    @_optimize(speed)
    @_transparent
    func renderPlainText() -> String {
        UnsafeNode.makeDocument(self) { document in
            String(cString: cmark_render_plaintext(document, CMARK_OPT_DEFAULT, 0))
        } ?? ""
    }
}

extension BlockNode {
    @_optimize(speed)
    @_transparent
    fileprivate init?(unsafeNode: UnsafeNode) {
        switch unsafeNode.nodeType {
            case .blockquote:
                self = .blockquote(children: unsafeNode.children.compactMap(BlockNode.init(unsafeNode:)))
            case .list:
                if unsafeNode.children.contains(where: \.isTaskListItem) {
                    self = .taskList(
                        isTight: unsafeNode.isTightList,
                        items: unsafeNode.children.map(RawTaskListItem.init(unsafeNode:))
                    )
                } else {
                    switch unsafeNode.listType {
                        case CMARK_BULLET_LIST:
                            self = .bulletedList(
                                isTight: unsafeNode.isTightList,
                                items: unsafeNode.children.map(RawListItem.init(unsafeNode:))
                            )
                        case CMARK_ORDERED_LIST:
                            self = .numberedList(
                                isTight: unsafeNode.isTightList,
                                start: unsafeNode.listStart,
                                items: unsafeNode.children.map(RawListItem.init(unsafeNode:))
                            )
                        default:
                            fatalError("cmark reported a list node without a list type.")
                    }
                }
            case .codeBlock:
                self = .codeBlock(fenceInfo: unsafeNode.fenceInfo, content: unsafeNode.literal ?? "")
            case .htmlBlock:
                self = .htmlBlock(content: unsafeNode.literal ?? "")
            case .paragraph:
                self = .paragraph(content: unsafeNode.children.compactMap(InlineNode.init(unsafeNode:)))
            case .heading:
                self = .heading(
                    level: unsafeNode.headingLevel,
                    content: unsafeNode.children.compactMap(InlineNode.init(unsafeNode:))
                )
            case .table:
                self = .table(
                    columnAlignments: unsafeNode.tableAlignments,
                    rows: unsafeNode.children.map(RawTableRow.init(unsafeNode:))
                )
            case .thematicBreak:
                self = .thematicBreak
            default:
                assertionFailure("Unhandled node type '\(unsafeNode.nodeType)' in BlockNode.")
                return nil
        }
    }
}

extension RawListItem {
    @_optimize(speed)
    @_transparent
    fileprivate init(unsafeNode: UnsafeNode) {
        guard unsafeNode.nodeType == .item else {
            fatalError("Expected a list item but got a '\(unsafeNode.nodeType)' instead.")
        }
        
        self.init(children: unsafeNode.children.compactMap(BlockNode.init(unsafeNode:)))
    }
}

extension RawTaskListItem {
    @_optimize(speed)
    @_transparent
    fileprivate init(unsafeNode: UnsafeNode) {
        guard unsafeNode.nodeType == .taskListItem || unsafeNode.nodeType == .item else {
            fatalError("Expected a list item but got a '\(unsafeNode.nodeType)' instead.")
        }
        
        self.init(
            isCompleted: unsafeNode.isTaskListItemChecked,
            children: unsafeNode.children.compactMap(BlockNode.init(unsafeNode:))
        )
    }
}

extension RawTableRow {
    @_optimize(speed)
    @_transparent
    fileprivate init(unsafeNode: UnsafeNode) {
        guard unsafeNode.nodeType == .tableRow || unsafeNode.nodeType == .tableHead else {
            fatalError("Expected a table row but got a '\(unsafeNode.nodeType)' instead.")
        }
        
        self.init(cells: unsafeNode.children.map(RawTableCell.init(unsafeNode:)))
    }
}

extension RawTableCell {
    @_optimize(speed)
    @_transparent
    fileprivate init(unsafeNode: UnsafeNode) {
        guard unsafeNode.nodeType == .tableCell else {
            fatalError("Expected a table cell but got a '\(unsafeNode.nodeType)' instead.")
        }
        
        self.init(content: unsafeNode.children.compactMap(InlineNode.init(unsafeNode:)))
    }
}

extension InlineNode {
    @_optimize(speed)
    @_transparent
    fileprivate init?(unsafeNode: UnsafeNode) {
        switch unsafeNode.nodeType {
            case .text:
                self = .text(unsafeNode.literal ?? "")
            case .softBreak:
                self = .softBreak
            case .lineBreak:
                self = .lineBreak
            case .code:
                self = .code(unsafeNode.literal ?? "")
            case .html:
                self = .html(unsafeNode.literal ?? "")
            case .emphasis:
                self = .emphasis(children: unsafeNode.children.compactMap(InlineNode.init(unsafeNode:)))
            case .strong:
                self = .strong(children: unsafeNode.children.compactMap(InlineNode.init(unsafeNode:)))
            case .strikethrough:
                self = .strikethrough(children: unsafeNode.children.compactMap(InlineNode.init(unsafeNode:)))
            case .link:
                self = .link(
                    destination: unsafeNode.url ?? "",
                    children: unsafeNode.children.compactMap(InlineNode.init(unsafeNode:))
                )
            case .image:
                self = .image(
                    source: unsafeNode.url ?? "",
                    children: unsafeNode.children.compactMap(InlineNode.init(unsafeNode:))
                )
            default:
                assertionFailure("Unhandled node type '\(unsafeNode.nodeType)' in InlineNode.")
                return nil
        }
    }
}
