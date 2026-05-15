import Foundation

final class KeychainService: KeychainServicing, @unchecked Sendable {
    private enum Keys {
        static let authToken = "auth_token"
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

}
