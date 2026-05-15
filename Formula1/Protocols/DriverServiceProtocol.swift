import Foundation

protocol DriverServiceProtocol {
    func fetchDrivers() async throws -> [Driver]
    func fetchDriver(by id: String) async throws -> Driver?
    func fetchDriverResults(driverId: String) async throws -> [RaceStatus.RaceResultEntry]
}
