import Dependencies

private enum KeychainServiceKey: DependencyKey {
    static var liveValue: any KeychainServicing {
        KeychainService()
    }
}

extension DependencyValues {
    var keychainService: any KeychainServicing {
        get { self[KeychainServiceKey.self] }
        set { self[KeychainServiceKey.self] = newValue }
    }
}
