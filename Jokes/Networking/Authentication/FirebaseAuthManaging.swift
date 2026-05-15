import Foundation

struct Credentials {
    let email: String
    let password: String
}

protocol FirebaseAuthManaging: Sendable {
    var isSignedIn: Bool { get }
    func signIn(_ credentials: Credentials) async throws
    func signUp(_ credentials: Credentials) async throws
    func signOut() throws
}
