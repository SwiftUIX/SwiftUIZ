//
// Copyright (c) Vatsal Manot
//

import Diagnostics
import Swallow
import SwiftUIX

/// A runtime discoverable alternative to `PreviewProvider`.
public protocol ViewPreview: Initiable, DynamicView {
    static var title: String { get }
}

extension ViewPreview {
    public static var title: String {
        let description = _ReadableCustomStringConvertible(from: Self.self).description
        
        return description.dropSuffixIfPresent(".Type")
    }
    
    @ViewBuilder
    public var body: some View {
        if #available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *) {
            ContentUnavailableView {
                Text("Unimplemented")
            }
        }
    }
}

public struct _ViewPreviewsContent: View {
    @UserStorage("selection") public var selection: _PreviewProviderDescriptor.ID?
    
    public var body: some View {
        NavigationSplitView {
            List(selection: $selection) {
                ForEach(_PreviewProviderDescriptor.allCases.sorted(by: { $0.title < $1.title })) { item in
                    Text(item.title)
                }
            }
            .frame(minWidth: 256)
        } detail: {
            Group {
                if let selection {
                    _PreviewProviderDescriptor.allCases.first(where: {
                        $0.id == selection
                    })?.content
                }
            }
            .frame(minWidth: 512)
        }
    }
}

/// A scene for all instances of `ViewPreview` that are discoverable at runtime.
public struct PreviewCatalogGroup: Initiable, _SceneX {
    private var contentModifier: AnyViewModifier?
    
    public var body: some Scene {
        WindowGroup(.dynamic) {
            if let contentModifier {
                _ViewPreviewsContent()
                    .modifier(contentModifier)
            } else {
                _ViewPreviewsContent()
            }
        }
    }
    
    public func contentModifier(
        _ contentModifier: AnyViewModifier
    ) -> Self {
        withMutableScope(self) {
            $0.contentModifier = contentModifier
        }
    }
    
    public func contentModifier<ModifierBody: View>(
        _ modify: @escaping (AnyViewModifier.Content) -> ModifierBody
    ) -> Self {
        self.contentModifier(AnyViewModifier(modify))
    }
    
    public init() {
        
    }
}
