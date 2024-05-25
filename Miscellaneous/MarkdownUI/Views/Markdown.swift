//
// Copyright (c) Vatsal Manot
//

import SwiftUI
private import SwiftUIZ

public struct Markdown: View {
    @Environment(\._markdownUnsafeFlags) var _markdownUnsafeFlags
    @Environment(\.theme.text) private var text
    
    private let content: MarkdownContent
    private let contentHash: Int
    private let baseURL: URL?
    private let imageBaseURL: URL?
        
    public var body: some View {
        _SwiftUI_UnaryViewAdaptor {
            VStack(alignment: .leading, spacing: 0) {
                TextStyleAttributesReader { attributes in
                    BlockSequence(self.content.blocks)
                        .foregroundColor(attributes.foregroundColor)
                        .background(attributes.backgroundColor)
                        .modifier(ScaledFontSizeModifier(attributes.fontProperties?.size))
                }
                .textStyle(self.text)
                .environment(\.baseURL, self.baseURL)
                .environment(\.imageBaseURL, self.imageBaseURL)
            }
            .modify { content in
                if #available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *) {
                    content.geometryGroup()
                } else {
                    content
                }
            }
        }
    }
}

extension Markdown {
    public init(
        _ content: MarkdownContent,
        baseURL: URL? = nil,
        imageBaseURL: URL? = nil
    ) {
        self.content = content
        self.contentHash = content.hashValue
        self.baseURL = baseURL
        self.imageBaseURL = imageBaseURL ?? baseURL
    }

    public init(
        _ markdown: String,
        baseURL: URL? = nil,
        imageBaseURL: URL? = nil
    ) {
        self.init(
            MarkdownContent(
                markdown
            ),
            baseURL: baseURL,
            imageBaseURL: imageBaseURL
        )
    }
}

// MARK: - Auxiliary

public enum _MarkdownUnsafeFlag {
    case nonLazyRendering
}

extension EnvironmentValues {
    @EnvironmentValue
    var _markdownUnsafeFlags: Set<_MarkdownUnsafeFlag> = []
}

private struct ScaledFontSizeModifier: ViewModifier {
    @ScaledMetric private var size: CGFloat
    
    init(_ size: CGFloat?) {
        self._size = ScaledMetric(
            wrappedValue: size ?? FontProperties.defaultSize,
            relativeTo: .body
        )
    }
    
    func body(content: Content) -> some View {
        content.markdownTextStyle {
            FontSize(self.size)
        }
    }
}
