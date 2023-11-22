//
// Copyright (c) Vatsal Manot
//

import Foundation
import Swallow
import SwiftUIX
import UniformTypeIdentifiers

@available(tvOS, unavailable)
public final class Pasteboard {
    public static let general: Pasteboard = {
        .init(base: .general)
    }()
    
    let base: AppKitOrUIKitPasteboard
    
    init(base: AppKitOrUIKitPasteboard) {
        self.base = base
    }
}

#if os(iOS) || os(tvOS) || os(visionOS)
@available(tvOS, unavailable)
extension Pasteboard {
    public func setString(_ string: String) {
        base.string = string
    }
}
#elseif os(macOS)
@available(tvOS, unavailable)
extension Pasteboard {
    public func setString(_ string: String) {
        base.clearContents()
        base.writeObjects([string as NSPasteboardWriting])
        base.setString(string, forType: .string)
    }
}
#endif

// MARK: - Auxiliary

#if os(macOS)
@MainActor
extension NSPasteboard {
    @MainActor
    public func withRestoration(
        perform: @MainActor @Sendable (NSPasteboard) async throws -> Void
    ) async rethrows {
        let items = self.copyItems()
        
        prepareForNewContents(with: .currentHostOnly)
        
        try await perform(self)
        
        try? await Task.sleep(.milliseconds(200))
        
        self.prepareForNewContents()
        
        if let items = items {
            for item in items {
                for type in item.types {
                    self.setData(item.data(forType: type), forType: type)
                }
            }
            
            self.writeObjects(items)
        }
    }
    
    public func copyItems() -> [NSPasteboardItem]? {
        guard let pasteboardItems = pasteboardItems else {
            return nil
        }
        
        return pasteboardItems.map { item in
            let item = NSPasteboardItem()
            
            for type in item.types {
                if let data = item.data(forType: type) {
                    item.setData(data, forType: type)
                }
            }
            
            return item
        }
    }
}
#endif

// MARK: - Helpers

extension String {
    fileprivate func _extractURLs() -> [URL] {
        let pattern = #"((?:http|https|ftp)://[^\s/$.?#].[^\s]*)"# // Regular expression pattern to match URLs
        let regex = try! NSRegularExpression(pattern: pattern, options: [])
        
        let matches = regex.matches(in: self, options: [], range: NSRange(bounds, in: self))
        
        var urls: [URL] = []
        
        for match in matches {
            let urlRange = match.range
            
            guard let _range = _fromUTF16Range(urlRange) else {
                assertionFailure()
                
                continue
            }
            
            if let url = URL(string: String(self[_range])) {
                urls.append(url)
            }
        }
        
        return urls
    }
}
