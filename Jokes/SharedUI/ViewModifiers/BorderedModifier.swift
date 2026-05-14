import SwiftUI

struct BorderedModifier: ViewModifier {
    var cornerRadius: CGFloat

    func body(content: Content) -> some View {
        content
            .background(.gray)
            .cornerRadius(cornerRadius)
            .overlay {
                RoundedRectangle(cornerRadius: cornerRadius)
                    .stroke(.white, lineWidth: 2)
            }
            .shadow(radius: 2)
    }
}

extension View {
    func bordered(cornerRadius: CGFloat) -> some View {
        modifier(BorderedModifier(cornerRadius: cornerRadius))
    }
}
