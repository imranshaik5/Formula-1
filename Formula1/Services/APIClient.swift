import Foundation
import Alamofire

enum APIError: LocalizedError {
    case invalidResponse
    case decodingFailed(Error)
    case networkError(Error)
    case noData

    var errorDescription: String? {
        switch self {
        case .invalidResponse: return "Invalid response from server"
        case .decodingFailed(let error): return "Failed to decode data: \(error.localizedDescription)"
        case .networkError(let error): return "Network error: \(error.localizedDescription)"
        case .noData: return "No data received"
        }
    }
}

final class APIClient {
    static let baseURL = "https://api.jolpi.ca/ergast/f1/"

    private let session: Session

    init(session: Session = .default) {
        self.session = session
    }

    func fetch<T: Decodable>(_ path: String) async throws -> T {
        let url = "\(Self.baseURL)\(path)"
        let response = try await session.request(url).serializingDecodable(T.self).value
        return response
    }
}
