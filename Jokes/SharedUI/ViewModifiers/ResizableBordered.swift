import SwiftUI

extension Image {
    func resizableBordered(cornerRadius: CGFloat) -> some View {
        self
            .resizable()
            .scaledToFill()
            .bordered(cornerRadius: cornerRadius)
    }
}
