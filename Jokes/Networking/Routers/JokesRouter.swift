import Foundation

enum JokesRouter: Endpoint {
    case getRandomJoke
    case getCategories
    case getJokeFor(category: String)

    var host: URL {
        // swiftlint:disable:next force_unwrapping
        URL(string: "https://api.chucknorris.io")!
    }

    var path: String {
        switch self {
        case .getRandomJoke, .getJokeFor: 
            "jokes/random"
        case .getCategories:
            "jokes/categories"
        }
    }

    var urlParameters: [String: String] {
        switch self {
        case let .getJokeFor(category):
            ["category": category]
        default:
            [:]
        }
    }
}
