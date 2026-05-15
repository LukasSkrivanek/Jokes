import SwiftUI

struct ProfileView: View {
    @ObservedObject var store: ProfileStore

    private let techStack = [
        "UIKit + SwiftUI (Hybrid)",
        "Coordinator Pattern",
        "EventEmitting (Combine)",
        "Store Pattern",
        "DiffableDataSource",
        "Async/Await + TaskGroup",
        "Dependencies (Point-Free)"
    ]

    var body: some View {
        ScrollView {
            VStack(spacing: 32) {
                header
                descriptionSection
                techStackSection
                actionsSection
            }
            .padding()
        }
        .background(Color.bg)
        .ignoresSafeArea()
        .navigationTitle("About")
    }
}

// MARK: - Sections
private extension ProfileView {
    var header: some View {
        VStack(spacing: 12) {
            Image(systemName: "face.smiling.inverse")
                .font(.system(size: 72))
                .foregroundStyle(.white)
                .padding(.top, 24)

            Text("Jokes")
                .textStyle(textType: .navigationTitle)

            Text("Browse, scratch and swipe through Chuck Norris joke categories.")
                .textStyle(textType: .caption)
                .multilineTextAlignment(.center)
        }
    }

    var descriptionSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("About the app")
                .textStyle(textType: .sectionTitle)

            Text("Jokes is a portfolio app demonstrating hybrid UIKit + SwiftUI architecture using the Coordinator pattern. Categories are built with UICollectionView and DiffableDataSource, while Swiping uses SwiftUI gestures with a scratch-card reveal effect.")
                .textStyle(textType: .caption)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    var techStackSection: some View {
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

    var actionsSection: some View {
        VStack(spacing: 12) {
            Button("Replay Onboarding") {
                store.send(.replayOnboarding)
            }
            .font(.headline)
            .foregroundStyle(.white)
            .frame(maxWidth: .infinity)
            .padding()
            .background(.brown)
            .cornerRadius(UIConstants.cornerRadius)

            Button("Log Out") {
                store.send(.logout)
            }
            .font(.headline)
            .foregroundStyle(.red)
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.gray.opacity(0.2))
            .cornerRadius(UIConstants.cornerRadius)
        }
    }
}
