import SwiftUI

struct OnboardingView: View {
    let page: OnboardingStore.Page
    @ObservedObject var store: OnboardingStore

    var body: some View {
        OnboardingPageView(
            symbolName: page.symbolName,
            title: page.title,
            subtitle: page.subtitle,
            buttonTitle: page.buttonTitle,
            onNext: {
                store.send(.next)
            },
            onSkip: page.isLast ? nil : {
                store.send(.close)
            }
        )
    }
}
