//
// Copyright (c) Vatsal Manot
//

import SwiftUI
import SwiftUIX
import UniformTypeIdentifiers

public struct _SwiftUIX_AnyPasteCommandDelegate {
    public var supportedContentTypes: [UTType]
    public var action: ([NSItemProvider]) -> Void
    
    public init(
        supportedContentTypes: [UTType],
        action: @escaping ([NSItemProvider]) -> Void
    ) {
        self.supportedContentTypes = supportedContentTypes
        self.action = action
    }
}

public struct _FocusableViewConfiguration: ExpressibleByNilLiteral {
    public enum Mode {
        case `default`
        case accessory
    }
    
    public var mode: Mode = .default
    public var _fixedSize: (horizontal: Bool, vertical: Bool)? = nil
    public var onMoveCommand: ((_SwiftUIX_MoveCommandDirection) -> Void)?
    public var onExitCommand: (() -> Void)?
    public var onDeleteCommand: (() -> Void)?
    
    public var pasteCommandHandler: _SwiftUIX_AnyPasteCommandDelegate?
    
    public init(
        mode: Mode,
        _fixedSize: (horizontal: Bool, vertical: Bool)? = nil,
        onMoveCommand: ((_SwiftUIX_MoveCommandDirection) -> Void)? = nil,
        onExitCommand: (() -> Void)? = nil,
        onDeleteCommand: (() -> Void)? = nil,
        pasteCommandHandler: _SwiftUIX_AnyPasteCommandDelegate? = nil
    ) {
        self.mode = mode
        self._fixedSize = _fixedSize
        self.onMoveCommand = onMoveCommand
        self.onExitCommand = onExitCommand
        self.onDeleteCommand = onDeleteCommand
        self.pasteCommandHandler = pasteCommandHandler
    }
    
    public init(nilLiteral: ()) {
        
    }
}
