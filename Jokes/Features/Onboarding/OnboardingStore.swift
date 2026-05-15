import Foundation
import Combine

final class OnboardingStore: ObservableObject {
    enum Page: Int, CaseIterable {
        case welcome, features, start

        var symbolName: String {
            switch self {
            case .welcome:
                "face.smiling.fill"
            case .features:
                "list.bullet.rectangle.fill"
            case .start:
                "hand.draw.fill"
            }
        }

        var title: String {
            switch self {
            case .welcome:
                "Welcome to Jokes"
            case .features:
                "Browse Categories"
            case .start:
                "Swipe & Scratch"
            }
        }

        var subtitle: String {
            switch self {
            case .welcome:
                "Discover thousands of Chuck Norris jokes organized by category."
            case .features:
                "Explore jokes across animal, science, sport and many more categories."
            case .start:
                "Swipe through joke cards and scratch to reveal the punchline."
            }
        }

        var buttonTitle: String {
            switch self {
            case .welcome, .features:
                "Next"
            case .start:
                "Let's go!"
            }
        }

        var isLast: Bool {
            self == .start
        }
    }

    struct State {
        var currentPage: Int = 0
        var isCompleted: Bool = false
    }

    enum Action {
        case next
        case close
    }

    @Published private(set) var state = State()

    @MainActor
    func send(_ action: Action) {
        switch action {
        case .next:
            if Page(rawValue: state.currentPage + 1) != nil {
                state.currentPage += 1
            } else {
                state.isCompleted = true
            }
        case .close:
            state.isCompleted = true
        }
    }
}
