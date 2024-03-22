//
// Copyright (c) Vatsal Manot
//

import SwiftUIX

public struct _AsymmetricInsertionRemoval<Content: View>: View {
    private let animation: Animation
    private let delay: (initial: Double?, insertion: Double, removal: Double)
    private let content: () -> Content?
    
    @State private var initialDelayApplied: Bool = false
    @State private var didAppear: Bool = false

    @State private var cachedContent: Content?
        
    public var body: some View {
        let resolvedContent = content()
        
        if let initial = delay.initial, !initialDelayApplied, !didAppear {
            ZeroSizeView().onAppear {
                withAnimation(animation, after: .milliseconds(Int(initial * 1000))) {
                    didAppear = true
                }
            }
        } else if let content = resolvedContent ?? cachedContent {
            let isInitiallyActive = delay.initial == nil && !didAppear
            
            LazyAppearView(initial: isInitiallyActive ? .active : .inactive) {
                content
                    .onAppear {
                        self.cachedContent = content
                        self.didAppear = true
                    }
            }
            .delay(.milliseconds(Int(delay.insertion * 1000)))
            .animation(animation)
            .onChange(of: resolvedContent == nil) { isNil in
                if isNil {
                    Task { @MainActor in
                        try? await Task.sleep(for: .milliseconds(delay.removal * 1000))
                        
                        withAnimation(animation) {
                            self.cachedContent = nil
                        }
                    }
                }
            }
        }
    }
}

extension _AsymmetricInsertionRemoval {
    public init(
        insert: Bool,
        animation: Animation,
        delay: (initial: Double?, insertion: Double, removal: Double),
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.animation = animation
        self.delay = delay
        self.content = { insert ? content() : nil }
    }
    
    public init(
        insert: Bool,
        animation: Animation,
        delay: (insertion: Double, removal: Double),
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.animation = animation
        self.delay = (nil, delay.insertion, delay.removal)
        self.content = { insert ? content() : nil }
    }
    
    public init(
        insert: Bool,
        animation: Animation,
        delay: Double,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.animation = animation
        self.delay = (nil, delay, delay)
        self.content = { insert ? content() : nil }
    }
}
