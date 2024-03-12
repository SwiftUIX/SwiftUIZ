//
// Copyright (c) Vatsal Manot
//

import SwiftUIX

extension ViewPrototypeBuilder {
    public struct ContainedWithin<Content: ViewPrototype> {
        public let anchor: _ViewPrototypeAnchor
        public let content: Content
        
        public var body: some View {
            _ModifyViewPrototype { expression in
                expression.merge(anchor)
            }
        }
    }
}

extension ViewPrototypeBuilder.ContainedWithin: ViewPrototype {
    public init<T: _SwiftUI_WithPlaceholderGenericTypeParameters>(
        _ type: T.Type,
        @ViewPrototypeBuilder content: () -> Content
    ) {
        self.anchor = .swiftUI(
            .init(
                type: type,
                parameter: nil
            )
        )
        self.content = content()
    }
}

// MARK: - Supplementary

extension ViewPrototype {
    public typealias ContainedWithin<Content: ViewPrototype> = ViewPrototypeBuilder.ContainedWithin<Content>
}
