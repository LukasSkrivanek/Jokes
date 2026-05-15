import Foundation

struct JokeResponse: Decodable {
    let id: String
    let categories: [String]
    let value: String
    let url: URL
    let createdAt: Date
}
