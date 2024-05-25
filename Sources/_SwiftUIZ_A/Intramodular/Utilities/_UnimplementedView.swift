//
// Copyright (c) Vatsal Manot
//

import Swallow
import SwiftUIX

@frozen
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

@frozen
public struct _UnimplementedView: View {
    @_transparent
    public var body: some View {
        Image(systemName: .exclamationmarkTriangleFill)
            .foregroundColor(.yellow)
            .padding(.small)
            .border(Color.red)
    }
    
    @_transparent
    public init(
        _ warning: StaticString? = nil,
        file: StaticString = #file,
        line: UInt = #line
    ) {
        runtimeIssue(warning ?? "This view is unimplemented.", file: file, line: line)
    }
}

extension Color {
    @_transparent
    public static var unimplemented: Self {
        runtimeIssue("This color is unimplemented.")
        
        return .cyan
    }
}
