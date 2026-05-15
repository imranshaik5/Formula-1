import Foundation

final class DriverService: DriverServiceProtocol {
    private let apiClient: APIClient

    init(apiClient: APIClient = APIClient()) {
        self.apiClient = apiClient
    }

    func fetchDrivers() async throws -> [Driver] {
        let response: JolpicaDriverStandingsResponse = try await apiClient.fetch("current/driverStandings")
        guard let standingsList = response.mrData.standingsTable.standingsLists.first,
              let standings = standingsList.driverStandings else {
            return []
        }
        return standings.map(Driver.init(jolpicaStanding:))
    }

    func fetchDriver(by id: String) async throws -> Driver? {
        let drivers = try await fetchDrivers()
        return drivers.first { $0.id == id }
    }

    func fetchDriverResults(driverId: String) async throws -> [RaceStatus.RaceResultEntry] {
        let response: JolpicaRaceResultResponse = try await apiClient.fetch("current/drivers/\(driverId)/results")
        let allResults = response.mrData.raceTable.races.flatMap { race in
            race.results.map { entry -> RaceStatus.RaceResultEntry in
                let driver = Driver(jolpicaResult: entry)
                let time = entry.time?.time
                let points = Int(entry.points ?? "0") ?? 0
                let grid = Int(entry.grid ?? "0") ?? 0
                let laps = Int(entry.laps ?? "0") ?? 0
                return RaceStatus.RaceResultEntry(driver: driver, time: time, points: points, grid: grid, laps: laps)
            }
        }
        return allResults.sorted { $0.driver.position < $1.driver.position }
    }
}
