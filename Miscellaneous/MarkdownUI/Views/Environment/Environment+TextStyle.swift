import SwiftUI

extension View {
    public func markdownTextStyle<S: TextStyle>(
        @TextStyleBuilder textStyle: @escaping () -> S
    ) -> some View {
        self.transformEnvironment(\.textStyle) {
            $0 = AnyTextStyle(erasing: $0.appending(textStyle()))
        }
    }
    
    func markdownTextStyle(
        _ textStyle: some TextStyle
    ) -> some View {
        self.transformEnvironment(\.textStyle) {
            $0 = AnyTextStyle(erasing: $0.appending(textStyle))
        }
    }
    
    func textStyleFont() -> some View {
        TextStyleAttributesReader { attributes in
            self.font(attributes.fontProperties.map(Font.withProperties))
        }
    }
    
    func textStyleForegroundColor() -> some View {
        TextStyleAttributesReader { attributes in
            self.foregroundColor(attributes.foregroundColor)
        }
    }
}

extension Text {
    func _useTextStyleAttributesReader() -> TextStyleAttributesReader<Text> {
        TextStyleAttributesReader { attributes in
            self
                .font(attributes.fontProperties.map(Font.withProperties))
                .foregroundColor(attributes.foregroundColor)
        }
    }
}

extension TextStyle {
    @TextStyleBuilder
    fileprivate consuming func appending<S: TextStyle>(
        _ textStyle: S
    ) -> some TextStyle {
        self
        textStyle
    }
}

extension EnvironmentValues {
    fileprivate(set) var textStyle: AnyTextStyle {
        get {
            self[TextStyleKey.self]
        } set {
            self[TextStyleKey.self] = newValue
        }
    }
}

private struct TextStyleKey: EnvironmentKey {
    static let defaultValue: AnyTextStyle = AnyTextStyle(erasing: FontProperties())
}
