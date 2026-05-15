import Foundation

protocol ConstructorServiceProtocol {
    func fetchConstructorStandings() async throws -> [ConstructorStanding]
}
