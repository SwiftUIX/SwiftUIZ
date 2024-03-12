//
// Copyright (c) Vatsal Manot
//

import Swallow
import SwiftUIX

public struct EitherView<Left, LeftContent: View, Right, RightContent: View>: View {
    private let value: Either<Left, Right>
    
    private let content: _ConditionalContent<LeftContent, RightContent>
    
    public init(
        _ value: Either<Left, Right>,
        @ViewBuilder leftContent: (Left) -> LeftContent,
        @ViewBuilder or rightContent: (Right) -> RightContent
    ) {
        self.value = value
        self.content = value.reduce(
            left: { ViewBuilder.buildEither(first: leftContent($0)) },
            right: { ViewBuilder.buildEither(second: rightContent($0)) }
        )
    }
    
    public init(
        _ value: Binding<Either<Left, Right>>,
        @ViewBuilder leftContent: (Binding<Left>) -> LeftContent,
        @ViewBuilder or rightContent: (Binding<Right>) -> RightContent
    ) {
        self.value = value.wrappedValue
        self.content = self.value.reduce(
            left: {
                ViewBuilder.buildEither(first: leftContent(value.unwrapLeft(default: $0)))
            },
            right: {
                ViewBuilder.buildEither(second: rightContent(value.unwrapRight(default: $0)))
            }
        )
    }
    
    public init(
        _ value: Binding<Either<Left, Right>>,
        @ViewBuilder leftContent: (Binding<Left>) -> LeftContent
    ) where RightContent == EmptyView {
        self.value = value.wrappedValue
        self.content = self.value.reduce(
            left: {
                ViewBuilder.buildEither(first: leftContent(value.unwrapLeft(default: $0)))
            },
            right: {
                _ in ViewBuilder.buildEither(second: EmptyView())
            }
        )
    }

    public var body: some View {
        content
    }
}
