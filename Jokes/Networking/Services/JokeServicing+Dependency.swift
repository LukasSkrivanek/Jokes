import Dependencies

private enum JokeServiceKey: DependencyKey {
    static var liveValue: any JokeServicing {
        JokeService()
    }
}

extension DependencyValues {
    var jokeService: any JokeServicing {
        get { self[JokeServiceKey.self] }
        set { self[JokeServiceKey.self] = newValue }
    }
}
