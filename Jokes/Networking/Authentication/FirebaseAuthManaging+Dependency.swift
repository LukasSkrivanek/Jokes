import Dependencies

private enum FirebaseAuthManagerKey: DependencyKey {
    static var liveValue: any FirebaseAuthManaging {
        FirebaseAuthManager()
    }
}

extension DependencyValues {
    var authManager: any FirebaseAuthManaging {
        get { self[FirebaseAuthManagerKey.self] }
        set { self[FirebaseAuthManagerKey.self] = newValue }
    }
}
