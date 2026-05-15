import Foundation

protocol RaceServiceProtocol {
    func fetchRaces() async throws -> [Race]
    func fetchRace(by id: String) async throws -> Race?
    func fetchRaceResults(round: Int) async throws -> RaceStatus.RaceResult?
}
