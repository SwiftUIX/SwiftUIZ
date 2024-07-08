//
// Copyright (c) Vatsal Manot
//

import SwiftUI

struct CodeBlockView: View {
    @Environment(\.theme.codeBlock) private var codeBlock
    @Environment(\.codeSyntaxHighlighter) private var codeSyntaxHighlighter
    
    private let fenceInfo: String?
    private let content: String
    
    init(fenceInfo: String?, content: String) {
        self.fenceInfo = fenceInfo
        self.content = content.hasSuffix("\n") ? String(content.dropLast()) : content
    }
    
    var body: some View {
        self.codeBlock.makeBody(
            configuration: .init(
                language: self.fenceInfo,
                content: self.content,
                label: CodeBlockConfiguration.Label(self.label)
            )
        )
    }
    
    private var label: some View {
        self.codeSyntaxHighlighter
            .highlightCode(self.content, language: self.fenceInfo)
            ._useTextStyleAttributesReader()
    }
}
