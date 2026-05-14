import UIKit
import Combine

struct JokeSection: Identifiable, Hashable, Sendable {
    nonisolated let id = UUID()
    nonisolated let title: String
    nonisolated let jokes: [Joke]
}

struct Joke: Identifiable, Hashable, Sendable {
    nonisolated let id = UUID()
    nonisolated let text: String
    nonisolated let imageName: String

    var image: UIImage? { UIImage(named: imageName) }
}

final class JokesDataProvider: ObservableObject {
    @Published var sections: [JokeSection]

    init() {
        sections = Self.mockSections
    }
}

private extension JokesDataProvider {
    static let mockSections: [JokeSection] = [
        JokeSection(title: "Animals", jokes: [
            Joke(text: "Why don't elephants use computers? They're afraid of the mouse!", imageName: "nature"),
            Joke(text: "What do you call a sleeping dinosaur? A dino-snore!", imageName: "nature"),
            Joke(text: "Why do fish swim in salt water? Because pepper makes them sneeze!", imageName: "nature")
        ]),
        JokeSection(title: "Food", jokes: [
            Joke(text: "Why don't eggs tell jokes? They'd crack up.", imageName: "food"),
            Joke(text: "What do you call a fake noodle? An impasta!", imageName: "food"),
            Joke(text: "Why did the banana go to the doctor? It wasn't peeling well!", imageName: "food")
        ]),
        JokeSection(title: "Technology", jokes: [
            Joke(text: "Why do programmers prefer dark mode? Because light attracts bugs!", imageName: "computer"),
            Joke(text: "A SQL query walks into a bar and asks two tables: Can I join you?", imageName: "computer"),
            Joke(text: "Why was the computer cold? It left its Windows open!", imageName: "computer")
        ])
    ]
}
