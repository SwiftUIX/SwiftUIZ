//
// Copyright (c) Vatsal Manot
//

import Swallow
import SwiftUIX

public struct _RuntimeWarningView: View {
    @usableFromInline
    let raiseIssue: () -> Void
    
    public var body: some View {
        Image(systemName: .exclamationmarkTriangleFill)
            .foregroundColor(.yellow)
            .padding(.small)
            .border(Color.red)
            .onAppear(perform: raiseIssue)
    }
    
    public init(
        _ warning: StaticString,
        file: StaticString = #file,
        line: UInt = #line
    ) {
        raiseIssue = {
            runtimeIssue(warning, file: file, line: line)
        }
    }
}

public struct _UnimplementedView: View {
    @usableFromInline
    let raiseIssue: () -> Void
    
    public var body: some View {
        Image(systemName: .exclamationmarkTriangleFill)
            .foregroundColor(.yellow)
            .padding(.small)
            .border(Color.red)
            .onAppear(perform: raiseIssue)
    }
    
    public init(
        file: StaticString = #file,
        line: UInt = #line
    ) {
        raiseIssue = {
            runtimeIssue("This view is unimplemented.", file: file, line: line)
        }
    }
}

extension Color {
    @_transparent
    public static var unimplemented: Self {
        runtimeIssue("This color is unimplemented.")
        
        return .cyan
    }
}
