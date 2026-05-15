import FirebaseAuth
import Foundation

final class FirebaseAuthManager: FirebaseAuthManaging {
    private let auth = Auth.auth()
    private let keychainService: KeychainServicing

    init(keychainService: KeychainServicing = KeychainService()) {
        self.keychainService = keychainService
    }

    func signIn(_ credentials: Credentials) async throws {
        let result = try await auth.signIn(withEmail: credentials.email, password: credentials.password)
        let token = try await result.user.getIDToken()
        try keychainService.storeAuthData(token)
    }

    func signUp(_ credentials: Credentials) async throws {
        let result = try await auth.createUser(withEmail: credentials.email, password: credentials.password)
        let token = try await result.user.getIDToken()
        try keychainService.storeAuthData(token)
    }

    func signOut() throws {
        try auth.signOut()
        try keychainService.removeAuthData()
    }
}
