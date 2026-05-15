import Foundation
import Combine

final class ProfileStore: ObservableObject {
    enum Action {
        case replayOnboarding
        case logout
    }

    struct State {}

    @Published private(set) var state = State()

    var onAction: ((Action) -> Void)?

    func send(_ action: Action) {
        onAction?(action)
    }
}
