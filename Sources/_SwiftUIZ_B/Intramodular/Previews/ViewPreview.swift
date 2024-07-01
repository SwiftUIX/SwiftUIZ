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

@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
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

@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
public struct _ViewPreviewsContent: Logging, View {
    //@UserStorage("selection")
    @State public var selection: _PreviewProviderDescriptor.ID?
    
    init() {
        if let selection {
            print(selection)
        }
    }
    
    var data: [_PreviewProviderDescriptor] {
        _PreviewProviderDescriptor.allCases.sorted(by: { $0.title < $1.title })
    }
    
    public var body: some View {
        NavigationSplitView {
            Group {
                if data.isEmpty {
                    ContentUnavailableView("No Previews")
                } else {
                    List(selection: $selection) {
                        ForEach(data) { item in
                            NavigationLink(value: item.id) {
                                Text(item.title)
                                    .id(item.id)
                            }
                        }
                    }
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
@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
public struct PreviewCatalogGroup: Initiable, _ExtendedScene {
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
