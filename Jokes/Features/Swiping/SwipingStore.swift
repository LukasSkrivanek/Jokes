import Foundation
import Combine

@MainActor
final class SwipingStore: ObservableObject {
    
    struct State {
        var sections: [JokeSection] = []
        var isLoading = false
        var error: Error?
    }

    enum Action {
        case load
        case sectionsLoaded([JokeSection])
        case failed(Error)
        case jokeRemoved(Joke)
    }

    @Published private(set) var state = State()

    private let service: JokeServicing
    private let category: String?

    init(service: JokeServicing = JokeService(), category: String? = nil) {
        self.service = service
        self.category = category
    }

    func send(_ action: Action) async {
        switch action {
        case .load:
            await loadJokes()

        case .sectionsLoaded(let sections):
            state.sections = sections
            state.isLoading = false

        case .failed(let error):
            state.error = error
            state.isLoading = false

        case .jokeRemoved(let joke):
            state.sections.removeAll { $0.jokes.contains(joke) }
        }
    }
}

// MARK: - Private
private extension SwipingStore {
    func loadJokes() async {
        if let category {
            await loadJokes(for: category)
        } else {
            await loadAllCategories()
        }
    }

    func loadJokes(for category: String) async {
        state.isLoading = true
        do {
            let jokes: [Joke] = try await withThrowingTaskGroup(of: Joke.self) { group in
                for _ in 0..<5 {
                    group.addTask {
                        let response = try await self.service.fetchJoke(for: category)
                        return Joke(id: response.id, text: response.value)
                    }
                }
                var result: [Joke] = []
                for try await joke in group { result.append(joke) }
                return result
            }
            let section = JokeSection(title: category.capitalized, jokes: jokes)
            await send(.sectionsLoaded([section]))
        } catch {
            await send(.failed(error))
        }
    }

    func loadAllCategories() async {
        state.isLoading = true
        do {
            let categories = try await service.fetchCategories()
            let sections: [JokeSection] = try await withThrowingTaskGroup(of: JokeSection.self) { group in
                for category in categories {
                    group.addTask {
                        let response = try await self.service.fetchJoke(for: category)
                        let joke = Joke(id: response.id, text: response.value)
                        return JokeSection(title: category.capitalized, jokes: [joke])
                    }
                }
                var result: [JokeSection] = []
                for try await section in group { result.append(section) }
                return result.sorted { $0.title < $1.title }
            }
            await send(.sectionsLoaded(sections))
        } catch {
            await send(.failed(error))
        }
    }
}
