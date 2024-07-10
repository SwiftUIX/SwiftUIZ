import SwiftUI

/// A text style that sets the foreground color of the text.
public struct ForegroundColor: Hashable, TextStyle {
    private let foregroundColor: Color?
    
    /// Creates a foreground color text style.
    /// - Parameter foregroundColor: The foreground color.
    public init(_ foregroundColor: Color?) {
        self.foregroundColor = foregroundColor
    }
    
    public func _collectAttributes(in attributes: inout AttributeContainer) {
        attributes.foregroundColor = self.foregroundColor
    }
}
