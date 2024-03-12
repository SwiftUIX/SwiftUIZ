//
// Copyright (c) Vatsal Manot
//

import Merge
import SwiftUIX

#if os(macOS)
extension AppKitOrUIKitImage {
    public func byPreparingThumbnail(
        ofSize thumbnailSize: NSSize
    ) async -> AppKitOrUIKitImage {
        let _self = _UncheckedSendable(self)
        
        return await Task(priority: .userInitiated) { () -> _UncheckedSendable<AppKitOrUIKitImage> in
            let thumbnail = NSImage(size: thumbnailSize)
            
            thumbnail.lockFocus()
            
            _self.wrappedValue.draw(
                in: NSRect(origin: .zero, size: thumbnailSize),
                from: NSRect(origin: .zero, size: _self.wrappedValue.size),
                operation: .sourceOver,
                fraction: 1.0
            )
            
            thumbnail.unlockFocus()
            
            return _UncheckedSendable(thumbnail)
        }
        .value
        .wrappedValue
    }
}
#endif
