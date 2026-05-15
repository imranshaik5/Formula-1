import Foundation

final class ConstructorService: ConstructorServiceProtocol {
    private let apiClient: APIClient

    init(apiClient: APIClient = APIClient()) {
        self.apiClient = apiClient
    }

    func fetchConstructorStandings() async throws -> [ConstructorStanding] {
        let response: JolpicaDriverStandingsResponse = try await apiClient.fetch("current/constructorStandings")
        guard let standingsList = response.mrData.standingsTable.standingsLists.first,
              let standings = standingsList.constructorStandings else {
            return []
        }
        return standings.map(ConstructorStanding.init(jolpicaStanding:))
    }

    func fetchConstructorResults(constructorId: String) async throws -> [ConstructorRaceResult] {
        let response: JolpicaRaceResultResponse = try await apiClient.fetch("current/constructors/\(constructorId)/results")
        let df = ISO8601DateFormatter()
        df.formatOptions = [.withInternetDateTime, .withDashSeparatorInDate, .withColonSeparatorInTime]

        let allRaces = response.mrData.raceTable.races
        var results: [ConstructorRaceResult] = []

        for race in allRaces {
            let dateString: String
            if let time = race.time {
                dateString = "\(race.date)T\(time)"
            } else {
                dateString = "\(race.date)T00:00:00Z"
            }

            let driverResults = race.results.map { entry -> ConstructorDriverResult in
                let jd = entry.driver
                let driverName = "\(jd.givenName) \(jd.familyName)"
                return ConstructorDriverResult(
                    driverId: jd.driverId,
                    driverName: driverName,
                    position: Int(entry.position) ?? 0,
                    points: Int(entry.points ?? "0") ?? 0,
                    grid: Int(entry.grid ?? "0") ?? 0,
                    laps: Int(entry.laps ?? "0") ?? 0,
                    status: entry.status,
                    time: entry.time?.time
                )
            }.sorted { $0.position < $1.position }

            let raceResult = ConstructorRaceResult(
                id: "\(race.season)-\(race.round)-\(constructorId)",
                round: Int(race.round) ?? 0,
                raceName: race.raceName,
                date: df.date(from: dateString) ?? Date(),
                circuitName: race.circuit.circuitName,
                driverResults: driverResults
            )
            results.append(raceResult)
        }

        return results.sorted { $0.round < $1.round }
    }
}
