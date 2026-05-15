import Dependencies
import Foundation
import Combine

@MainActor
final class SwipingStore: ObservableObject {

    struct State {
        var cards: [Card] = []
        var isLoading = false
        var error: Error?

        struct Card: Identifiable, Hashable {
            let id: String
            let categoryTitle: String
            let jokeText: String
        }
    }

    enum Action {
        case load
        case cardsLoaded([State.Card])
        case failed(Error)
        case cardRemoved(State.Card)
    }

    @Published private(set) var state = State()

    @Dependency(\.jokeService) var service
    private let category: String?

    init(category: String? = nil) {
        self.category = category
    }

    func send(_ action: Action) async {
        switch action {
        case .load:
            await loadJokes()

        case .cardsLoaded(let cards):
            state.cards = cards
            state.isLoading = false

        case .failed(let error):
            state.error = error
            state.isLoading = false

        case .cardRemoved(let card):
            state.cards.removeAll { $0.id == card.id }
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
            let cards: [State.Card] = try await withThrowingTaskGroup(of: State.Card.self) { group in
                for _ in 0..<5 {
                    group.addTask {
                        let response = try await self.service.fetchJoke(for: category)
                        return State.Card(id: response.id, categoryTitle: category.capitalized, jokeText: response.value)
                    }
                }
                var result: [State.Card] = []
                for try await card in group { result.append(card) }
                return result
            }
            await send(.cardsLoaded(cards))
        } catch {
            await send(.failed(error))
        }
    }

    func loadAllCategories() async {
        state.isLoading = true
        do {
            let categories = try await service.fetchCategories()
            let cards: [State.Card] = try await withThrowingTaskGroup(of: State.Card.self) { group in
                for category in categories {
                    group.addTask {
                        let response = try await self.service.fetchJoke(for: category)
                        return State.Card(id: response.id, categoryTitle: category.capitalized, jokeText: response.value)
                    }
                }
                var result: [State.Card] = []
                for try await card in group { result.append(card) }
                return result.sorted { $0.categoryTitle < $1.categoryTitle }
            }
            await send(.cardsLoaded(cards))
        } catch {
            await send(.failed(error))
        }
    }
}
