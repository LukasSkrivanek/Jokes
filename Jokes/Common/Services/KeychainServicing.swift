import Foundation

protocol KeychainServicing: Sendable {
    func storeAuthData(_ token: String) throws
    func fetchAuthData() throws -> String
    func removeAuthData() throws
    func storeEmail(_ email: String) throws
    func fetchEmail() throws -> String
    func removeEmail() throws
}
