//
// Copyright (c) Vatsal Manot
//

import Foundation
import SwiftUI

indirect enum BlockNode: Hashable {
    case blockquote(children: [BlockNode])
    case bulletedList(isTight: Bool, items: [RawListItem])
    case numberedList(isTight: Bool, start: Int, items: [RawListItem])
    case taskList(isTight: Bool, items: [RawTaskListItem])
    case codeBlock(fenceInfo: String?, content: String)
    case htmlBlock(content: String)
    case paragraph(content: [InlineNode])
    case heading(level: Int, content: [InlineNode])
    case table(columnAlignments: [RawTableColumnAlignment], rows: [RawTableRow])
    case thematicBreak
}

extension BlockNode: View {
    var body: some View {
        switch self {
            case .blockquote(let children):
                BlockquoteView(children: children)
            case .bulletedList(let isTight, let items):
                BulletedListView(isTight: isTight, items: items)
                    .equatable()
            case .numberedList(let isTight, let start, let items):
                NumberedListView(isTight: isTight, start: start, items: items)
            case .taskList(let isTight, let items):
                TaskListView(isTight: isTight, items: items)
            case .codeBlock(let fenceInfo, let content):
                CodeBlockView(fenceInfo: fenceInfo, content: content)
            case .htmlBlock(let content):
                ParagraphView(content: content)
                    .equatable()
            case .paragraph(let content):
                ParagraphView(content: content)
                    .equatable()
            case .heading(let level, let content):
                HeadingView(level: level, content: content)
            case .table(let columnAlignments, let rows):
                if #available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *) {
                    TableView(columnAlignments: columnAlignments, rows: rows)
                }
            case .thematicBreak:
                ThematicBreakView()
        }
    }
}

extension BlockNode {
    var children: [BlockNode] {
        switch self {
            case .blockquote(let children):
                return children
            case .bulletedList(_, let items):
                return items.map(\.children).flatMap { $0 }
            case .numberedList(_, _, let items):
                return items.map(\.children).flatMap { $0 }
            case .taskList(_, let items):
                return items.map(\.children).flatMap { $0 }
            default:
                return []
        }
    }
    
    var isParagraph: Bool {
        guard case .paragraph = self else {
            return false
        }
        
        return true
    }
}

struct RawListItem: Hashable {
    let children: [BlockNode]
}

struct RawTaskListItem: Hashable {
    let isCompleted: Bool
    let children: [BlockNode]
}

enum RawTableColumnAlignment: Character {
    case none = "\0"
    case left = "l"
    case center = "c"
    case right = "r"
}

struct RawTableRow: Hashable {
    let cells: [RawTableCell]
}

struct RawTableCell: Hashable {
    let content: [InlineNode]
}
