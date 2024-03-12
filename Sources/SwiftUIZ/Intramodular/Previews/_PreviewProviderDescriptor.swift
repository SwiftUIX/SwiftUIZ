//
// Copyright (c) Vatsal Manot
//

import _ModularDecodingEncoding
import Runtime
import Swallow

public struct _PreviewProviderDescriptor: Identifiable {
    public let type: _SerializedTypeIdentity
    public let title: String
    public let content: AnyView
    
    public var id: String {
        try! _getSanitizedTypeName(from: type.resolveType(), qualified: false)
    }
    
    public init<Content: View>(
        type: _SerializedTypeIdentity,
        title: String,
        _ content: Content
    ) {
        self.type = type
        self.title = title
        self.content = content.eraseToAnyView()
    }
}

extension _PreviewProviderDescriptor {
    init(from view: any ViewPreview.Type) {        
        self.init(
            type: _SerializedTypeIdentity(from: view),
            title: view.title,
            view.init().eraseToAnyView()
        )
    }
}

// MARK: - Conformances

extension _PreviewProviderDescriptor: CaseIterable {
    public static let allCases: [_PreviewProviderDescriptor] = {
        RuntimeDiscoverableTypes
            .enumerate(
                typesConformingTo: (any ViewPreview).self
            )
            .map {
                _PreviewProviderDescriptor(from: $0)
            }
    }()
}
