import Foundation

protocol ConstructorServiceProtocol {
    func fetchConstructorStandings() async throws -> [ConstructorStanding]
    func fetchConstructorResults(constructorId: String) async throws -> [ConstructorRaceResult]
}

struct ConstructorRaceResult: Identifiable, Hashable {
    let id: String
    let round: Int
    let raceName: String
    let date: Date
    let circuitName: String
    let driverResults: [ConstructorDriverResult]
}

struct ConstructorDriverResult: Hashable {
    let driverId: String
    let driverName: String
    let position: Int
    let points: Int
    let grid: Int
    let laps: Int
    let status: String
    let time: String?
}
