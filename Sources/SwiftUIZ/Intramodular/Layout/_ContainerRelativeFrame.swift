//
// Copyright (c) Vatsal Manot
//

import SwiftUIIntrospect
import Swallow
import SwiftUIX

public enum _SwiftUI_ContainerType {
    case window
    case sheet
    case navigationSplitViewColumn
    case tabViewTab
    case scrollableView
}

/// Different things can represent a “container” including:
///
/// - The window presenting a view on iPadOS or macOS, or the screen of a device on iOS.
/// - A column of a NavigationSplitView
/// - A NavigationStack
/// - A tab of a TabView
/// - A scrollable view like ScrollView or List
struct _SwiftUIX_ContainerRelativeFrame: ViewModifier {
    let container: _SwiftUI_ContainerType
    let axes: Axis.Set
    let alignment: Alignment
    let length: (CGFloat, Axis) -> CGFloat
    
    @WeakState private var window: AppKitOrUIKitWindow?
    @WeakState private var view: AppKitOrUIKitView?

    @StateObject var observedFrame = _NSKeyValueObservedKeyPath<AppKitOrUIKitWindow, CGRect, CGSize>(keyPath: \.frame, member: \.size)
    
    var relativeWidth: CGFloat? {
        guard axes.contains(.horizontal) else {
            return nil
        }
        
        return observedFrame.value.map({ length($0.width, .horizontal) })
    }
    
    var relativeHeight: CGFloat? {
        guard axes.contains(.vertical) else {
            return nil
        }
        
        guard let height = observedFrame.value.map({ length($0.height, .vertical) }) else {
            return nil
        }
        
        if container == .window, let window = window {
            return height - (window._SwiftUIX_contentView?.safeAreaInsets.top ?? 0)
        } else {
            return height
        }
    }
    
    func body(content: Content) -> some View {
        content
            .frame(width: relativeWidth, height: relativeHeight, alignment: alignment)
            ._introspectAppKitOrUIKitWindow { window in
                self.window = window
                self.observedFrame.target = window
            }
    }
}


extension View {
    public func containerRelativeFrame(
        _ container: _SwiftUI_ContainerType,
        _ axes: Axis.Set,
        alignment: Alignment = .center,
        _ length: @escaping (CGFloat, Axis) -> CGFloat
    ) -> some View {
        modifier(
            _SwiftUIX_ContainerRelativeFrame(
                container: container,
                axes: axes,
                alignment: alignment,
                length: length
            )
        )
    }
}
