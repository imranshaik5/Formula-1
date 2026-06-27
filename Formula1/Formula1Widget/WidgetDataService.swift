import Foundation

struct WidgetRaceData: Codable, Equatable {
    let nextRaceName: String
    let nextRaceDate: Date
    let nextRaceRound: Int
    let topDriverName: String
    let topDriverTeam: String
    let topConstructorName: String
    let topConstructorPoints: Int
}

final class WidgetDataService {
    private let baseURL = "https://api.jolpi.ca/ergast/f1/"
    private let decoder: JSONDecoder
    private let dateFormatter: ISO8601DateFormatter

    init() {
        decoder = JSONDecoder()
        dateFormatter = ISO8601DateFormatter()
        dateFormatter.formatOptions = [.withInternetDateTime, .withDashSeparatorInDate, .withColonSeparatorInTime]
    }

    func fetchWidgetData() async -> WidgetRaceData {
        let now = Date()

        let races = (try? await fetchRaces()) ?? []
        let allDrivers = (try? await fetchDriverStandings()) ?? []
        let allConstructors = (try? await fetchConstructorStandings()) ?? []

        let nextRace = races
            .filter { $0.date > now }
            .min { $0.date < $1.date }

        let topDriver = allDrivers.first
        let topConstructor = allConstructors.first

        return WidgetRaceData(
            nextRaceName: nextRace?.name ?? "Season Complete",
            nextRaceDate: nextRace?.date ?? now,
            nextRaceRound: nextRace?.round ?? 0,
            topDriverName: topDriver.map { "\($0.givenName) \($0.familyName)" } ?? "—",
            topDriverTeam: topDriver?.team ?? "—",
            topConstructorName: topConstructor?.name ?? "—",
            topConstructorPoints: topConstructor?.points ?? 0
        )
    }

    private func fetchRaces() async throws -> [RaceEntry] {
        let data = try await fetch("current/")
        let response = try decoder.decode(JolpicaRaceListResponse.self, from: data)
        return response.mrData.raceTable.races.compactMap { jRace in
            let ds: String
            if let t = jRace.time {
                ds = "\(jRace.date)T\(t)"
            } else {
                ds = "\(jRace.date)T00:00:00Z"
            }
            guard let date = dateFormatter.date(from: ds) else { return nil }
            return RaceEntry(round: Int(jRace.round) ?? 0, name: jRace.raceName, date: date)
        }
    }

    private func fetchDriverStandings() async throws -> [DriverEntry] {
        let data = try await fetch("current/driverStandings/")
        let response = try decoder.decode(JolpicaStandingsResponse.self, from: data)
        guard let list = response.mrData.standingsTable.standingsLists.first,
              let standings = list.driverStandings else {
            return []
        }
        return standings.map { entry in
            let d = entry.driver
            let team = entry.constructors.first?.name ?? ""
            return DriverEntry(
                position: Int(entry.position) ?? 0,
                givenName: d.givenName,
                familyName: d.familyName,
                points: Int(entry.points) ?? 0,
                team: team
            )
        }.sorted { $0.position < $1.position }
    }

    private func fetchConstructorStandings() async throws -> [ConstructorEntry] {
        let data = try await fetch("current/constructorStandings/")
        let response = try decoder.decode(JolpicaStandingsResponse.self, from: data)
        guard let list = response.mrData.standingsTable.standingsLists.first,
              let standings = list.constructorStandings else {
            return []
        }
        return standings.map { entry in
            ConstructorEntry(
                position: Int(entry.position) ?? 0,
                name: entry.constructor.name,
                points: Int(entry.points) ?? 0
            )
        }.sorted { $0.position < $1.position }
    }

    private func fetch(_ path: String) async throws -> Data {
        guard let url = URL(string: "\(baseURL)\(path)") else {
            throw URLError(.badURL)
        }
        var request = URLRequest(url: url, timeoutInterval: 10)
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        let (data, response) = try await URLSession.shared.data(for: request)
        guard let http = response as? HTTPURLResponse, (200...299).contains(http.statusCode) else {
            throw URLError(.badServerResponse)
        }
        return data
    }
}

// MARK: - Internal Models

struct RaceEntry {
    let round: Int
    let name: String
    let date: Date
}

struct DriverEntry {
    let position: Int
    let givenName: String
    let familyName: String
    let points: Int
    let team: String
}

struct ConstructorEntry {
    let position: Int
    let name: String
    let points: Int
}

// MARK: - API Response Models

struct JolpicaRaceListResponse: Decodable {
    let mrData: MRDataRaceTable
    enum CodingKeys: String, CodingKey {
        case mrData = "MRData"
    }
}

struct MRDataRaceTable: Decodable {
    let raceTable: RaceTable
    enum CodingKeys: String, CodingKey {
        case raceTable = "RaceTable"
    }
}

struct RaceTable: Decodable {
    let races: [JolpicaRaceEntry]
    enum CodingKeys: String, CodingKey {
        case races = "Races"
    }
}

struct JolpicaRaceEntry: Decodable {
    let round: String
    let raceName: String
    let date: String
    let time: String?
    enum CodingKeys: String, CodingKey {
        case round, date, time
        case raceName = "raceName"
    }
}

struct JolpicaStandingsResponse: Decodable {
    let mrData: MRDataStandings
    enum CodingKeys: String, CodingKey {
        case mrData = "MRData"
    }
}

struct MRDataStandings: Decodable {
    let standingsTable: StandingsTable
    enum CodingKeys: String, CodingKey {
        case standingsTable = "StandingsTable"
    }
}

struct StandingsTable: Decodable {
    let standingsLists: [StandingsList]
    enum CodingKeys: String, CodingKey {
        case standingsLists = "StandingsLists"
    }
}

struct StandingsList: Decodable {
    let driverStandings: [JolpicaDriverStandingEntry]?
    let constructorStandings: [JolpicaConstructorStandingEntry]?
    enum CodingKeys: String, CodingKey {
        case driverStandings = "DriverStandings"
        case constructorStandings = "ConstructorStandings"
    }
}

struct JolpicaDriverStandingEntry: Decodable {
    let position: String
    let points: String
    let driver: JolpicaDriverEntry
    let constructors: [JolpicaConstructorSummary]
    enum CodingKeys: String, CodingKey {
        case position, points
        case driver = "Driver"
        case constructors = "Constructors"
    }
}

struct JolpicaDriverEntry: Decodable {
    let givenName: String
    let familyName: String
    enum CodingKeys: String, CodingKey {
        case givenName, familyName
    }
}

struct JolpicaConstructorSummary: Decodable {
    let name: String
    enum CodingKeys: String, CodingKey {
        case name
    }
}

struct JolpicaConstructorStandingEntry: Decodable {
    let position: String
    let points: String
    let constructor: JolpicaConstructorSummary
    enum CodingKeys: String, CodingKey {
        case position, points
        case constructor = "Constructor"
    }
}
