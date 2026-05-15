import Foundation

final class KeychainService: KeychainServicing {
    private enum Keys {
        static let authToken = "auth_token"
        static let email = "user_email"
    }

    private let manager: KeychainManaging

    init(manager: KeychainManaging = KeychainManager()) {
        self.manager = manager
    }

    func storeAuthData(_ token: String) throws {
        try manager.store(key: Keys.authToken, value: token)
    }

    func fetchAuthData() throws -> String {
        try manager.fetch(key: Keys.authToken)
    }

    func removeAuthData() throws {
        try manager.remove(key: Keys.authToken)
    }

    func storeEmail(_ email: String) throws {
        try manager.store(key: Keys.email, value: email)
    }

    func fetchEmail() throws -> String {
        try manager.fetch(key: Keys.email)
    }

    func removeEmail() throws {
        try manager.remove(key: Keys.email)
    }
}
