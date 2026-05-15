import Foundation

protocol Endpoint {
    var host: URL { get }
    var path: String { get }
    var method: HTTPMethod { get }
    var headers: [String: String] { get }
    var urlParameters: [String: String] { get }

    func asURLRequest() throws -> URLRequest
}
