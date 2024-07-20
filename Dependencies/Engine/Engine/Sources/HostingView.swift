//
// Copyright (c) Nathan Tannar
//

import SwiftUI

#if !os(watchOS)

#if os(macOS)
public typealias PlatformHostingView<Content: View> = NSHostingView<Content>
#else
public typealias PlatformHostingView<Content: View> = _UIHostingView<Content>
#endif

@available(macOS 10.15, iOS 13.0, tvOS 13.0, *)
open class HostingView<
    Content: View
>: PlatformHostingView<Content> {

    public var content: Content {
        get {
            #if os(macOS)
            return rootView
            #else
            if #available(iOS 16.0, tvOS 16.0, *) {
                return rootView
            } else {
                do {
                    return try swift_getFieldValue("_rootView", Content.self, self)
                } catch {
                    fatalError("\(error)")
                }
            }
            #endif
        }
        set {
            #if os(macOS)
            rootView = newValue
            #else
            if #available(iOS 16.0, tvOS 16.0, *) {
                rootView = newValue
            } else {
                do {
                    var flags = try swift_getFieldValue("propertiesNeedingUpdate", UInt16.self, self)
                    try swift_setFieldValue("_rootView", newValue, self)
                    flags |= 1
                    try swift_setFieldValue("propertiesNeedingUpdate", flags, self)
                    setNeedsLayout()
                } catch {
                    fatalError("\(error)")
                }
            }
            #endif
        }
    }

    public var disablesSafeArea: Bool = false

    #if os(iOS) || os(tvOS)
    @available(iOS 16.0, tvOS 16.0, *)
    public var allowUIKitAnimationsForNextUpdate: Bool {
        get {
            let result = try? swift_getFieldValue("allowUIKitAnimationsForNextUpdate", Bool.self, self)
            return result ?? false
        }
        set {
            try? swift_setFieldValue("allowUIKitAnimationsForNextUpdate", newValue, self)
        }
    }

    @available(iOS 16.0, tvOS 16.0, *)
    public var automaticallyAllowUIKitAnimationsForNextUpdate: Bool {
        get { shouldAutomaticallyAllowUIKitAnimationsForNextUpdate }
        set { shouldAutomaticallyAllowUIKitAnimationsForNextUpdate = newValue }
    }
    private var shouldAutomaticallyAllowUIKitAnimationsForNextUpdate: Bool = true
    #endif

    #if os(macOS)
    @available(macOS 11.0, *)
    open override var safeAreaInsets: NSEdgeInsets {
        disablesSafeArea ? NSEdgeInsets() : super.safeAreaInsets
    }
    #else
    open override var safeAreaInsets: UIEdgeInsets {
        disablesSafeArea ? .zero : super.safeAreaInsets
    }
    #endif

    public init(content: Content) {
        super.init(rootView: content)
        #if os(macOS)
        layer?.backgroundColor = nil
        #else
        backgroundColor = nil
        #endif
        clipsToBounds = false
    }

    public convenience init(@ViewBuilder content: () -> Content) {
        self.init(content: content())
    }

    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @available(iOS, obsoleted: 13.0, renamed: "init(content:)")
    @available(tvOS, obsoleted: 13.0, renamed: "init(content:)")
    @available(macOS, obsoleted: 10.15, renamed: "init(content:)")
    public required init(rootView: Content) {
        fatalError("init(rootView:) has not been implemented")
    }

    #if os(iOS) || os(tvOS)
    open override func layoutSubviews() {
        if #available(iOS 16.0, tvOS 16.0, *), shouldAutomaticallyAllowUIKitAnimationsForNextUpdate, 
            UIView.inheritedAnimationDuration > 0 || layer.animationKeys()?.isEmpty == false
        {
            allowUIKitAnimationsForNextUpdate = true
        }
        super.layoutSubviews()
    }
    #endif

    #if os(macOS)
    open override func hitTest(_ point: NSPoint) -> NSView? {
        guard let result = super.hitTest(point), result != self else {
            return nil
        }
        return result
    }
    #else
    public override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        guard let result = super.hitTest(point, with: event), result != self else {
            return nil
        }
        return result
    }
    #endif
}

#endif // !os(watchOS)
