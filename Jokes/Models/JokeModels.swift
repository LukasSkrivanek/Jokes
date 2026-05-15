import Foundation
import Combine

struct JokeSection: Identifiable, Hashable, Sendable {
    nonisolated let id = UUID()
    nonisolated let title: String
    nonisolated let jokes: [Joke]
}

struct Joke: Identifiable, Hashable, Sendable {
    nonisolated let id: String
    nonisolated let text: String
}

@MainActor
final class JokesDataProvider: ObservableObject {
    @Published var sections: [JokeSection] = []
    @Published var isLoading = false
    @Published var error: Error?

    private let service: JokeServicing

    init(service: JokeServicing = JokeService()) {
        self.service = service
    }

    func load() async {
        isLoading = true
        defer { isLoading = false }
        do {
            let categories = try await service.fetchCategories()
            sections = try await withThrowingTaskGroup(of: JokeSection.self) { group in
                for category in categories {
                    group.addTask {
                        let response = try await self.service.fetchJoke(for: category)
                        let joke = Joke(id: response.id, text: response.value)
                        return JokeSection(title: category.capitalized, jokes: [joke])
                    }
                }
                var result: [JokeSection] = []
                for try await section in group {
                    result.append(section)
                }
                return result.sorted { $0.title < $1.title }
            }
        } catch {
            self.error = error
        }
    }
}
