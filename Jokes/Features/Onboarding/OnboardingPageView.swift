import SwiftUI

struct OnboardingPageView: View {
    let symbolName: String
    let title: String
    let subtitle: String
    let buttonTitle: String
    let onNext: () -> Void
    let onSkip: (() -> Void)?

    var body: some View {
        VStack(spacing: 24) {
            Spacer()

            Image(systemName: symbolName)
                .font(.system(size: 90))
                .foregroundStyle(.brown)

            Text(title)
                .textStyle(textType: .sectionTitle)
                .multilineTextAlignment(.center)

            Text(subtitle)
                .textStyle(textType: .baseText)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 32)

            Spacer()

            Button(buttonTitle, action: onNext)
                .font(.headline)
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity)
                .padding()
                .background(.brown)
                .cornerRadius(UIConstants.cornerRadius)
                .padding(.horizontal, 32)

            if let onSkip {
                Button("Skip", action: onSkip)
                    .textStyle(textType: .caption)
                    .padding(.bottom, 8)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.bg)
    }
}
