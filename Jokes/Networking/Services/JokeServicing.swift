import Foundation

protocol JokeServicing {
    func fetchRandomJoke() async throws -> JokeResponse
    func fetchCategories() async throws -> [String]
    func fetchJoke(for category: String) async throws -> JokeResponse
}
