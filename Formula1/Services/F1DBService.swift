import Foundation

@MainActor
final class F1DBService: ObservableObject {
    @Published private(set) var isLoaded = false
    @Published private(set) var isLoading = false
    @Published private(set) var error: Error?

    private var root: F1DBRoot?
    private var driversByID: [String: F1DBDriver] = [:]
    private var constructorsByID: [String: F1DBConstructor] = [:]
    private var circuitsByID: [String: F1DBCircuit] = [:]
    private var grandsPrixByID: [String: F1DBGrandPrix] = [:]
    private var racesByID: [Int: F1DBRace] = [:]
    private var countriesByID: [String: F1DBCountry] = [:]
    private var seasonsByYear: [Int: F1DBSeason] = [:]
    private var racesByYearAndRound: [Int: [Int: F1DBRace]] = [:]

    private let cacheURL: URL
    private let jsonURL = URL(string: "https://github.com/f1db/f1db/releases/download/v2026.4.2/f1db-json-single.zip")!

    init() {
        let caches = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first!
        cacheURL = caches.appendingPathComponent("f1db-cache.json")
    }

    func load() async {
        if let data = try? loadFromBundle() {
            if parse(data) { return }
        }
        if let cached = try? loadFromCache() {
            if parse(cached) { return }
        }
        await refresh()
    }

    func refresh() async {
        isLoading = true
        error = nil
        defer { isLoading = false }

        do {
            let data = try await downloadAndDecompress()
            if parse(data) {
                saveToCache(data)
            }
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
    func race(id: Int) -> F1DBRace? { racesByID[id] }

    func race(year: Int, round: Int) -> F1DBRace? {
        racesByYearAndRound[year]?[round]
    }

    func racesFor(year: Int) -> [F1DBRace] {
        racesByYearAndRound[year]?.values.sorted { $0.round < $1.round } ?? []
    }

    func allDrivers() -> [F1DBDriver] { Array(driversByID.values) }
    func allConstructors() -> [F1DBConstructor] { Array(constructorsByID.values) }

    func countryName(id: String) -> String {
        countriesByID[id]?.name ?? id
    }

    // MARK: - Private

    private func parse(_ data: Data) -> Bool {
        let decoder = JSONDecoder()
        do {
            let root = try decoder.decode(F1DBRoot.self, from: data)
            self.root = root
            buildIndexes()
            isLoaded = true
            return true
        } catch {
            self.error = error
            return false
        }
    }

    private func buildIndexes() {
        guard let root else { return }
        driversByID = Dictionary(uniqueKeysWithValues: root.drivers.map { ($0.id, $0) })
        constructorsByID = Dictionary(uniqueKeysWithValues: root.constructors.map { ($0.id, $0) })
        circuitsByID = Dictionary(uniqueKeysWithValues: root.circuits.map { ($0.id, $0) })
        grandsPrixByID = Dictionary(uniqueKeysWithValues: root.grandsPrix.map { ($0.id, $0) })
        countriesByID = Dictionary(uniqueKeysWithValues: root.countries.map { ($0.id, $0) })
        seasonsByYear = Dictionary(uniqueKeysWithValues: root.seasons.map { ($0.year, $0) })
        for race in root.races {
            racesByID[race.id] = race
            if racesByYearAndRound[race.year] == nil { racesByYearAndRound[race.year] = [:] }
            racesByYearAndRound[race.year]?[race.round] = race
        }
    }

    private func loadFromBundle() throws -> Data? {
        guard let url = Bundle.main.url(forResource: "f1db", withExtension: "json") else { return nil }
        return try Data(contentsOf: url)
    }

    private func loadFromCache() throws -> Data? {
        guard FileManager.default.fileExists(atPath: cacheURL.path) else { return nil }
        return try Data(contentsOf: cacheURL)
    }

    private func saveToCache(_ data: Data) {
        try? data.write(to: cacheURL, options: .atomic)
    }

    private func downloadAndDecompress() async throws -> Data {
        let session = URLSession.shared
        let (zipData, _) = try await session.data(from: jsonURL)
        #if os(macOS)
        return try decompressZipMacOS(zipData)
        #else
        throw F1DBError.decompressionNotAvailable
        #endif
    }

    #if os(macOS)
    private func decompressZipMacOS(_ zipData: Data) throws -> Data {
        let tempDir = FileManager.default.temporaryDirectory.appendingPathComponent(UUID().uuidString)
        try FileManager.default.createDirectory(at: tempDir, withIntermediateDirectories: true)
        defer { try? FileManager.default.removeItem(at: tempDir) }

        let zipPath = tempDir.appendingPathComponent("data.zip")
        try zipData.write(to: zipPath)

        let process = Process()
        process.executableURL = URL(fileURLWithPath: "/usr/bin/unzip")
        process.arguments = ["-o", zipPath.path, "-d", tempDir.path]
        try process.run()
        process.waitUntilExit()

        var jsonFile = tempDir.appendingPathComponent("f1db.json")
        if !FileManager.default.fileExists(atPath: jsonFile.path) {
            let contents = try FileManager.default.contentsOfDirectory(at: tempDir, includingPropertiesForKeys: nil)
            if let subdir = contents.first(where: { $0.hasDirectoryPath }) {
                jsonFile = subdir.appendingPathComponent("f1db.json")
            }
        }
        return try Data(contentsOf: jsonFile)
    }
    #endif
}

enum F1DBError: LocalizedError {
    case decompressionNotAvailable

    var errorDescription: String? {
        switch self {
        case .decompressionNotAvailable:
            return "F1DB data needs to be bundled. Add f1db.json to app Resources."
        }
    }
}
