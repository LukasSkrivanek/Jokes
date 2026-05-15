import Foundation

enum HTTPStatusCode: Int, Error {
    enum ResponseType {
        case informational
        case success
        case redirection
        case clientError
        case serverError
        case undefined
    }

    case ok = 200
    case created = 201
    case badRequest = 400
    case unauthorized = 401
    case forbidden = 403
    case notFound = 404
    case internalServerError = 500

    var responseType: ResponseType {
        switch rawValue {
        case 100..<200:
            .informational
        case 200..<300:
            .success
        case 300..<400:
            .redirection
        case 400..<500:
            .clientError
        case 500..<600:
            .serverError
        default:
            .undefined
        }
    }
}

extension HTTPURLResponse {
    var status: HTTPStatusCode? {
        HTTPStatusCode(rawValue: statusCode)
    }
}
