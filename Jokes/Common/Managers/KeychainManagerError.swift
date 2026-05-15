import Foundation

enum KeychainManagerError: Error {
    case encodingError(Error)
    case decodingError(Error)
    case dataNotFound
    case storeFailed(OSStatus)
    case removeFailed(OSStatus)
}
