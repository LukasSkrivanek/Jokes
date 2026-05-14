import SwiftUI

private struct TextStyleModifier: ViewModifier {
    let textType: TextType

    func body(content: Content) -> some View {
        content
            .font(textType.font)
            .foregroundColor(textType.color)
    }
}

extension View {
    func textStyle(textType: TextType) -> some View {
        modifier(TextStyleModifier(textType: textType))
    }
}
