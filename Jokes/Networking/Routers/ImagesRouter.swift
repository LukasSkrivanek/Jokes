import Foundation

enum ImagesRouter: Endpoint {
    case random

    var host: URL {
        // swiftlint:disable:next force_unwrapping
        URL(string: "https://picsum.photos")!
    }

    var path: String {
        "300/200"
    }
}
