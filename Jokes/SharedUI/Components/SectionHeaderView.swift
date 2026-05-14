import SwiftUI

struct SectionHeaderView: View {
    let title: String

    var body: some View {
        Text(title)
            .padding()
            .textStyle(textType: .sectionTitle)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(.bg)
    }
}
