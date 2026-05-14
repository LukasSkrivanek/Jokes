import SwiftUI

struct ProfileView: View {
    private let techStack = ["UIKit", "SwiftUI", "Combine", "Coordinator Pattern", "DiffableDataSource"]

    var body: some View {
        ScrollView {
            VStack(spacing: 32) {
                header
                descriptionSection
                techStackSection
            }
            .padding()
        }
        .background(Color.bg)
        .ignoresSafeArea()
        .navigationTitle("About")
    }

    private var header: some View {
        VStack(spacing: 12) {
            Image(systemName: "face.smiling.inverse")
                .font(.system(size: 72))
                .foregroundStyle(.white)
                .padding(.top, 24)

            Text("Jokes")
                .textStyle(textType: .navigationTitle)

            Text("Browse, scratch and swipe through joke categories.")
                .textStyle(textType: .caption)
                .multilineTextAlignment(.center)
        }
    }

    private var descriptionSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("About the app")
                .textStyle(textType: .sectionTitle)

            Text("Jokes is a portfolio app demonstrating hybrid UIKit + SwiftUI architecture using the Coordinator pattern. Categories are built with UICollectionView and DiffableDataSource, while Swiping uses SwiftUI gestures with a scratch-card reveal effect.")
                .textStyle(textType: .caption)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    private var techStackSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Tech stack")
                .textStyle(textType: .sectionTitle)

            ForEach(techStack, id: \.self) { tech in
                HStack(spacing: 8) {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundStyle(.green)
                    Text(tech)
                        .textStyle(textType: .baseText)
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}
