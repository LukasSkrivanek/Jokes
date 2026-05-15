import Foundation

extension Endpoint {
    var method: HTTPMethod { .get }
    var headers: [String: String] { [:] }
    var urlParameters: [String: String] { [:] }

    func asURLRequest() throws -> URLRequest {
        let url = host.appendingPathComponent(path)

        guard var components = URLComponents(url: url, resolvingAgainstBaseURL: true) else {
            throw NetworkingError.invalidUrlComponents
        }

        if !urlParameters.isEmpty {
            components.queryItems = urlParameters.map {
                URLQueryItem(name: $0.key, value: $0.value)
            }
        }

        guard let finalURL = components.url else {
            throw NetworkingError.invalidUrlComponents
        }

        var request = URLRequest(url: finalURL)
        request.httpMethod = method.rawValue
        request.allHTTPHeaderFields = headers
        request.setValue(
            HTTPHeader.ContentType.json.rawValue,
            forHTTPHeaderField: HTTPHeader.HeaderField.contentType.rawValue
        )
        return request
    }
}
