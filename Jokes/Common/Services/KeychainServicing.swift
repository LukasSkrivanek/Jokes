import Foundation

protocol KeychainServicing: Sendable {
    func storeAuthData(_ token: String) throws
    func fetchAuthData() throws -> String
    func removeAuthData() throws
}
