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
        let numberOfJokesPerCategory = 3
        do {
            let categories = try await service.fetchCategories()
            var responses: [JokeResponse] = []
            try await withThrowingTaskGroup(of: JokeResponse.self) { group in
                for category in categories {
                    for _ in 0..<numberOfJokesPerCategory {
                        group.addTask {
                            try await self.service.fetchJoke(for: category)
                        }
                    }
                }
                for try await response in group {
                    responses.append(response)
                }
            }
            var seen = Set<String>()
            let uniqueResponses = responses.filter { seen.insert($0.id).inserted }
            let grouped = Dictionary(grouping: uniqueResponses) { $0.categories.first ?? "" }
            sections = grouped
                .filter { !$0.key.isEmpty }
                .map { category, categoryResponses in
                    JokeSection(
                        title: category.capitalized,
                        jokes: categoryResponses.map { Joke(id: $0.id, text: $0.value) }
                    )
                }
                .sorted { $0.title < $1.title }
        } catch {
            self.error = error
        }
    }
}
