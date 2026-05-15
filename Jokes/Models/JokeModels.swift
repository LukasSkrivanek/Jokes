import Foundation

struct JokeSection: Identifiable, Hashable, Sendable {
    nonisolated let id = UUID()
    nonisolated let title: String
    nonisolated let jokes: [Joke]
}

struct Joke: Identifiable, Hashable, Sendable {
    nonisolated let id: String
    nonisolated let text: String
}
