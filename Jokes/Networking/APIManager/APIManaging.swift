import Foundation

protocol APIManaging {
    func request<T: Decodable>(_ endpoint: any Endpoint) async throws -> T
}
