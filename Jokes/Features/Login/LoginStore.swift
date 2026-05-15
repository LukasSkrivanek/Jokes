import Combine
import Dependencies
import Foundation

final class LoginStore: ObservableObject {
    struct State {
        var email: String = ""
        var password: String = ""
        var rememberMe: Bool = false
        var isLoading: Bool = false
        var errorMessage: String?
    }

    enum Action {
        case viewDidAppear
        case rememberMeChanged(Bool)
        case signIn
        case signUp
    }

    @Published var state = State()

    @Dependency(\.authManager) private var authManager
    @Dependency(\.keychainService) private var keychainService

    private let eventSubject = PassthroughSubject<LoginEvent, Never>()

    var eventPublisher: AnyPublisher<LoginEvent, Never> {
        eventSubject.eraseToAnyPublisher()
    }

    @MainActor
    func send(_ action: Action) {
        switch action {
        case .viewDidAppear:
            loadStoredEmail()
        case .rememberMeChanged(let remember):
            state.rememberMe = remember
            if remember {
                try? keychainService.storeEmail(state.email)
            } else {
                try? keychainService.removeEmail()
            }
        case .signIn:
            Task { await signIn() }
        case .signUp:
            Task { await signUp() }
        }
    }
}

// MARK: - Private
private extension LoginStore {
    func loadStoredEmail() {
        if let email = try? keychainService.fetchEmail() {
            state.email = email
            state.rememberMe = true
        }
    }

    func signIn() async {
        state.isLoading = true
        state.errorMessage = nil
        defer { state.isLoading = false }
        do {
            let credentials = Credentials(email: state.email, password: state.password)
            try await authManager.signIn(credentials)
            if state.rememberMe {
                try? keychainService.storeEmail(state.email)
            }
            eventSubject.send(.loggedIn)
        } catch {
            state.errorMessage = error.localizedDescription
        }
    }

    func signUp() async {
        state.isLoading = true
        state.errorMessage = nil
        defer { state.isLoading = false }
        do {
            let credentials = Credentials(email: state.email, password: state.password)
            try await authManager.signUp(credentials)
            eventSubject.send(.loggedIn)
        } catch {
            state.errorMessage = error.localizedDescription
        }
    }
}
