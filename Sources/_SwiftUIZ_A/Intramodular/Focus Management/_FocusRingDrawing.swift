//
// Copyright (c) Vatsal Manot
//

import Swallow
import SwiftUIX

public struct _FocusRingDrawing: AppKitOrUIKitViewRepresentable {
    public let draw: Bool
    
    public init(draw: Bool) {
        self.draw = draw
    }
    
    public func makeAppKitOrUIKitView(context: Context) -> AppKitOrUIKitViewType {
        AppKitOrUIKitViewType()
    }
    
    public func updateAppKitOrUIKitView(_ view: AppKitOrUIKitViewType, context: Context) {
        view.drawFocusRing = draw
    }
}

#if os(iOS) || os(tvOS) || os(visionOS) || os(watchOS)
extension _FocusRingDrawing {
    public class AppKitOrUIKitViewType: AppKitOrUIKitView {
        fileprivate var drawFocusRing: Bool = false
    }
}
#elseif os(macOS)
extension _FocusRingDrawing {
    public class AppKitOrUIKitViewType: AppKitOrUIKitView {
        fileprivate var drawFocusRing: Bool = false {
            didSet {
                guard drawFocusRing != oldValue else {
                    return
                }
                
                self.needsDisplay = true
            }
        }
        
        override public func draw(_ dirtyRect: NSRect) {
            super.draw(dirtyRect)
            
            if drawFocusRing {
                NSFocusRingPlacement.only.set()
                NSGraphicsContext.saveGraphicsState()
                NSFocusRingPlacement.only.set()
                
                self.bounds.fill()
                
                NSGraphicsContext.restoreGraphicsState()
            }
        }
    }
}
#endif
