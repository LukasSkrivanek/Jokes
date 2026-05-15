import Foundation

final class JokeService: JokeServicing {
    private let apiManager: APIManaging

    init(apiManager: APIManaging = APIManager.shared) {
        self.apiManager = apiManager
    }

    func fetchRandomJoke() async throws -> JokeResponse {
        try await apiManager.request(JokesRouter.getRandomJoke)
    }

    func fetchCategories() async throws -> [String] {
        try await apiManager.request(JokesRouter.getCategories)
    }

    func fetchJoke(for category: String) async throws -> JokeResponse {
        try await apiManager.request(JokesRouter.getJokeFor(category: category))
    }
}
