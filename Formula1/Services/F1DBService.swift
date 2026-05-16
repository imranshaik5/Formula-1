import Foundation

@MainActor
final class F1DBService: ObservableObject {
    @Published private(set) var isLoaded = false
    @Published private(set) var isLoading = false
    @Published private(set) var error: Error?

    private var driversByID: [String: F1DBDriver] = [:]
    private var constructorsByID: [String: F1DBConstructor] = [:]
    private var circuitsByID: [String: F1DBCircuit] = [:]
    private var grandsPrixByID: [String: F1DBGrandPrix] = [:]
    private var countriesByID: [String: F1DBCountry] = [:]
    private var seasonsByYear: [Int: F1DBSeason] = [:]
    private var racesByYearAndRound: [Int: [Int: F1DBRace]] = [:]
    private var racesByCircuitID: [String: [F1DBRace]] = [:]

    private let cacheURL: URL

    init() {
        let caches = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first!
        cacheURL = caches.appendingPathComponent("f1db-cache.json")
        loadSynchronously()
    }

    private func loadSynchronously() {
        isLoading = true
        defer { isLoading = false }

        guard let url = Bundle.main.url(forResource: "f1db", withExtension: "json") else {
            error = F1DBError.bundleNotFound
            return
        }

        do {
            let data = try Data(contentsOf: url)
            let decoder = JSONDecoder()
            let root = try decoder.decode(F1DBRoot.self, from: data)

            driversByID = Dictionary(uniqueKeysWithValues: root.drivers.map { ($0.id, $0) })
            constructorsByID = Dictionary(uniqueKeysWithValues: root.constructors.map { ($0.id, $0) })
            circuitsByID = Dictionary(uniqueKeysWithValues: root.circuits.map { ($0.id, $0) })
            grandsPrixByID = Dictionary(uniqueKeysWithValues: root.grandsPrix.map { ($0.id, $0) })
            countriesByID = Dictionary(uniqueKeysWithValues: root.countries.map { ($0.id, $0) })
            seasonsByYear = Dictionary(uniqueKeysWithValues: root.seasons.map { ($0.year, $0) })

            for race in root.races {
                if racesByYearAndRound[race.year] == nil { racesByYearAndRound[race.year] = [:] }
                racesByYearAndRound[race.year]?[race.round] = race

                let cid = race.circuitId
                if racesByCircuitID[cid] == nil { racesByCircuitID[cid] = [] }
                racesByCircuitID[cid]?.append(race)
            }

            isLoaded = true
        } catch {
            self.error = error
        }
    }

    // MARK: - Queries

    func driver(id: String) -> F1DBDriver? { driversByID[id] }
    func constructor(id: String) -> F1DBConstructor? { constructorsByID[id] }
    func circuit(id: String) -> F1DBCircuit? { circuitsByID[id] }
    func grandPrix(id: String) -> F1DBGrandPrix? { grandsPrixByID[id] }
    func country(id: String) -> F1DBCountry? { countriesByID[id] }
    func season(year: Int) -> F1DBSeason? { seasonsByYear[year] }

    func race(year: Int, round: Int) -> F1DBRace? {
        racesByYearAndRound[year]?[round]
    }

    func racesFor(year: Int) -> [F1DBRace] {
        racesByYearAndRound[year]?.values.sorted { $0.round < $1.round } ?? []
    }

    func racesAtCircuit(circuitId: String) -> [F1DBRace] {
        racesByCircuitID[circuitId]?.sorted { $0.year > $1.year } ?? []
    }

    func allDrivers() -> [F1DBDriver] { Array(driversByID.values) }
    func allConstructors() -> [F1DBConstructor] { Array(constructorsByID.values) }

    func countryName(id: String) -> String {
        countriesByID[id]?.name ?? id
    }

    // MARK: - Circuit Performance

    func averageFinishForDriver(driverId: String, circuitId: String, maxRaces: Int = 5) -> Double? {
        let circuitRaces = racesAtCircuit(circuitId: circuitId).prefix(maxRaces)
        var finishes: [Int] = []
        for race in circuitRaces {
            if let results = race.raceResults,
               let result = results.first(where: { $0.driverId == driverId }),
               let pos = result.positionNumber {
                finishes.append(pos)
            }
        }
        guard !finishes.isEmpty else { return nil }
        return Double(finishes.reduce(0, +)) / Double(finishes.count)
    }

    func averageFinishForConstructor(constructorId: String, circuitId: String, maxRaces: Int = 5) -> Double? {
        let circuitRaces = racesAtCircuit(circuitId: circuitId).prefix(maxRaces)
        var finishes: [Int] = []
        for race in circuitRaces {
            if let results = race.raceResults {
                let constructorResults = results.filter { $0.constructorId == constructorId }
                let positions = constructorResults.compactMap { $0.positionNumber }
                if !positions.isEmpty {
                    finishes.append(positions.min() ?? positions.reduce(0, +) / positions.count)
                }
            }
        }
        guard !finishes.isEmpty else { return nil }
        return Double(finishes.reduce(0, +)) / Double(finishes.count)
    }

    func driverResultsLastRaces(driverId: String, circuitId: String? = nil, limit: Int = 8) -> [(position: Int, year: Int, round: Int)] {
        var results: [(Int, Int, Int)] = []
        for year in (2020...2026).reversed() {
            guard let yearRaces = racesByYearAndRound[year] else { continue }
            for round in yearRaces.keys.sorted().reversed() {
                guard results.count < limit else { break }
                guard let race = yearRaces[round] else { continue }
                if let circuitId, race.circuitId != circuitId { continue }
                if let raceResults = race.raceResults,
                   let result = raceResults.first(where: { $0.driverId == driverId }),
                   let pos = result.positionNumber {
                    results.append((pos, year, round))
                }
            }
            if results.count >= limit { break }
        }
        return results.map { ($0.0, $0.1, $0.2) }
    }

    func qualifyingPerformanceAtCircuit(driverId: String, circuitId: String, maxRaces: Int = 3) -> Double? {
        let circuitRaces = racesAtCircuit(circuitId: circuitId).prefix(maxRaces)
        var positions: [Int] = []
        for race in circuitRaces {
            if let quali = race.qualifyingResults,
               let result = quali.first(where: { $0.driverId == driverId }),
               let pos = result.positionNumber {
                positions.append(pos)
            }
        }
        guard !positions.isEmpty else { return nil }
        return Double(positions.reduce(0, +)) / Double(positions.count)
    }
}

enum F1DBError: LocalizedError {
    case bundleNotFound

    var errorDescription: String? {
        switch self {
        case .bundleNotFound:
            return "f1db.json not found in app bundle."
        }
    }
}

