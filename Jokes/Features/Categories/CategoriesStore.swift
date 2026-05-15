import Combine
import Dependencies
import Foundation

final class CategoriesStore: ObservableObject {
    struct State {
        var sections: [JokeSection] = []
        var isLoading = false
        var error: Error?
    }

    enum Action {
        case load
    }

    @Published private(set) var state = State()

    @Dependency(\.jokeService) var service

    @MainActor
    func send(_ action: Action) async {
        switch action {
        case .load:
            await load()
        }
    }
}

// MARK: - Private
private extension CategoriesStore {
    func load() async {
        state.isLoading = true
        defer { state.isLoading = false }
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
            state.sections = grouped
                .filter { !$0.key.isEmpty }
                .map { category, categoryResponses in
                    JokeSection(
                        title: category.capitalized,
                        jokes: categoryResponses.map { Joke(id: $0.id, text: $0.value) }
                    )
                }
                .sorted { $0.title < $1.title }
        } catch {
            state.error = error
        }
    }
}
