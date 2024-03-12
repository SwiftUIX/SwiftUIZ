//
// Copyright (c) Vatsal Manot
//

import SwiftUIX

struct InlineText: Equatable, View {
    private let inlines: [InlineNode]
    
    init(_ inlines: [InlineNode]) {
        self.inlines = inlines
    }
    
    var body: some View {
        _InlineText(inlines)
    }
}

private struct _InlineText: View {
    @Environment(\.inlineImageProvider) private var inlineImageProvider
    @Environment(\.baseURL) private var baseURL
    @Environment(\.imageBaseURL) private var imageBaseURL
    @Environment(\.theme) private var theme
    
    @State private var inlineImages: [String: Image] = [:]
    
    private let inlines: [InlineNode]
    
    init(_ inlines: [InlineNode]) {
        self.inlines = inlines
    }
    
    var body: some View {
        TextStyleAttributesReader { attributes in
            self.inlines.renderText(
                baseURL: self.baseURL,
                textStyles: InlineTextStyles(
                    code: self.theme.code,
                    emphasis: self.theme.emphasis,
                    strong: self.theme.strong,
                    strikethrough: self.theme.strikethrough,
                    link: self.theme.link
                ),
                images: self.inlineImages,
                attributes: attributes
            )
        }
        .task(id: self.inlines) {
            self.inlineImages = (try? await self.loadInlineImages()) ?? [:]
        }
    }
    
    private func loadInlineImages() async throws -> [String: Image] {
        let images = Set(self.inlines.compactMap(\.imageData))
        guard !images.isEmpty else { return [:] }
        
        return try await withThrowingTaskGroup(of: (String, Image).self) { taskGroup in
            for image in images {
                guard let url = URL(string: image.source, relativeTo: self.imageBaseURL) else {
                    continue
                }
                
                taskGroup.addTask {
                    (image.source, try await self.inlineImageProvider.image(with: url, label: image.alt))
                }
            }
            
            var inlineImages: [String: Image] = [:]
            
            for try await result in taskGroup {
                inlineImages[result.0] = result.1
            }
            
            return inlineImages
        }
    }
}
