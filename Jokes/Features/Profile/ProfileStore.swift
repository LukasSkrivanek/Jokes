import Combine
import Foundation

final class ProfileStore: ObservableObject {
    enum Action {
        case replayOnboarding
        case logout
    }

    struct State {}

    @Published private(set) var state = State()

    private let eventSubject = PassthroughSubject<ProfileEvent, Never>()

    var eventPublisher: AnyPublisher<ProfileEvent, Never> {
        eventSubject.eraseToAnyPublisher()
    }

    @MainActor
    func send(_ action: Action) {
        switch action {
        case .replayOnboarding:
            eventSubject.send(.replayOnboarding)
        case .logout:
            eventSubject.send(.logout)
        }
    }
}
