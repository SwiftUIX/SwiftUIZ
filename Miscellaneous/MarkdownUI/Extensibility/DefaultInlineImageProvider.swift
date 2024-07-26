//
// Copyright (c) Vatsal Manot
//

internal import _SwiftUIZ_Nuke
import SwiftUI
internal import SwiftUIX

public struct DefaultInlineImageProvider: InlineImageProvider {
    private let urlSession: URLSession
    
    public init(urlSession: URLSession = .shared) {
        self.urlSession = urlSession
    }
    
    public func image(with url: URL, label: String) async throws -> Image {
        let request = ImageRequest(
            url: url,
            processors: [],
            priority: .high,
            options: []
        )
        
        let image = try await ImagePipeline.shared.image(for: request)
        
        return Image(image: image)
    }
}

extension InlineImageProvider where Self == DefaultInlineImageProvider {
    public static var `default`: Self {
        .init()
    }
}
