import Foundation

struct Credentials {
    let email: String
    let password: String
}

protocol FirebaseAuthManaging {
    func signIn(_ credentials: Credentials) async throws
    func signUp(_ credentials: Credentials) async throws
    func signOut() throws
}
