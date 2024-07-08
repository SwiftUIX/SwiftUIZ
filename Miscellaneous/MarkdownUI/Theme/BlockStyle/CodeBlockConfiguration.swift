import SwiftUI

/// The properties of a Markdown code block.
///
/// The theme ``Theme/codeBlock`` block style receives a `CodeBlockConfiguration`
/// input in its `body` closure.
public struct CodeBlockConfiguration {
    /// A type-erased view of a Markdown code block.
    public struct Label: View {
        public let body: AnyView
        
        init<L: View>(_ label: L) {
            self.body = AnyView(label)
        }
    }
    
    /// The code block language, if present.
    public let language: String?
    
    /// The code block contents.
    public let content: String
    
    /// The code block view.
    public let label: Label
}
