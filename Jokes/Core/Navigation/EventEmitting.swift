import Combine

protocol EventEmitting {
    associatedtype Event
    var eventPublisher: AnyPublisher<Event, Never> { get }
}
