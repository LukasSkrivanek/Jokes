import Foundation

enum NetworkingError: Error {
    case invalidUrlComponents
    case noHttpResponse
    case unacceptableStatusCode
    case decodingFailed(error: Error)
}
