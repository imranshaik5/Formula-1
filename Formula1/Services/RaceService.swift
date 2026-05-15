import Foundation

final class RaceService: RaceServiceProtocol {
    private let apiClient: APIClient

    init(apiClient: APIClient = APIClient()) {
        self.apiClient = apiClient
    }

    func fetchRaces() async throws -> [Race] {
        let response: JolpicaRaceResponse = try await apiClient.fetch("current")
        return response.mrData.raceTable.races.enumerated().map { index, jRace in
            Race(jolpicaRace: jRace, roundIndex: index)
        }
    }

    func fetchRace(by id: String) async throws -> Race? {
        let races = try await fetchRaces()
        return races.first { $0.id == id }
    }

    func fetchRaceResults(round: Int) async throws -> RaceStatus.RaceResult? {
        let response: JolpicaRaceResultResponse = try await apiClient.fetch("current/\(round)/results")
        guard let race = response.mrData.raceTable.races.first else { return nil }
        let sorted = race.results.sorted { ($0.position as NSString).integerValue < ($1.position as NSString).integerValue }
        guard let winnerResult = sorted.first else { return nil }

        let winner = Driver(jolpicaResult: winnerResult)
        let podium = sorted.prefix(3).map(Driver.init(jolpicaResult:))
        let totalLaps = sorted.compactMap { entry in entry.laps.flatMap { Int($0) } }.max() ?? 0
        let fullResults = sorted.map { entry -> RaceStatus.RaceResultEntry in
            let driver = Driver(jolpicaResult: entry)
            let time = entry.time?.time
            let points = Int(entry.points ?? "0") ?? 0
            let grid = Int(entry.grid ?? "0") ?? 0
            let laps = Int(entry.laps ?? "0") ?? 0
            return RaceStatus.RaceResultEntry(driver: driver, time: time, points: points, grid: grid, laps: laps)
        }
        let fastestLap: RaceStatus.FastestLap? = {
            let flEntries = sorted.compactMap { entry -> (JolpicaFastestLap, Driver)? in
                guard let fl = entry.fastestLap else { return nil }
                return (fl, Driver(jolpicaResult: entry))
            }
            guard let fastest = flEntries.min(by: { Int($0.0.rank) ?? 999 < Int($1.0.rank) ?? 999 }) else { return nil }
            return RaceStatus.FastestLap(
                driver: fastest.1,
                lap: Int(fastest.0.lap) ?? 0,
                time: fastest.0.time?.time ?? "",
                speed: fastest.0.averageSpeed?.speed ?? ""
            )
        }()
        let details = RaceStatus.RaceDetails(fastestLap: fastestLap, totalLaps: totalLaps)
        return RaceStatus.RaceResult(winner: winner, podium: podium, fullResults: fullResults, details: details)
    }
}
