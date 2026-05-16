import Foundation

struct DriverPrediction: Identifiable {
    let id: String
    let driverId: String
    let driverName: String
    let driverAbbreviation: String
    let teamName: String
    let score: Double
    let predictedPosition: Int
    let winProbability: Double
    let factors: [PredictionFactor]
    let reasoning: String?
}

struct PredictionFactor: Identifiable {
    let id = UUID()
    let label: String
    let value: String
    let weight: Double
}

@MainActor
struct F1DBPredictor {
    private let f1db: F1DBService

    init(f1db: F1DBService) {
        self.f1db = f1db
    }

    func predictTop5(for race: F1DBRace? = nil) -> [DriverPrediction] {
        let allConstructors = f1db.allConstructors()
        let circuitId = race?.circuitId
        let circuit = circuitId.flatMap { f1db.circuit(id: $0) }

        let activeDrivers: [F1DBDriver]
        let driverStandings: [F1DBSeasonDriverStanding]
        var teamMap: [String: String]

        if f1db.isLoaded {
            let season = race.flatMap { f1db.season(year: $0.year) }
            teamMap = buildTeamMap(season: season)
            driverStandings = season?.driverStandings ?? []
            activeDrivers = filterActiveDrivers(season: season)
        } else {
            teamMap = [:]
            driverStandings = []
            activeDrivers = Self.fallbackDrivers
        }

        let scored = activeDrivers.compactMap { driver -> DriverPrediction? in
            guard driver.totalRaceEntries > 0 else { return nil }

            let constructorID = teamMap[driver.id] ?? driverIdToConstructorID(driver.id)
            let constructor = allConstructors.first { $0.id == constructorID }

            let careerForm = computeCareerForm(driver: driver, constructor: constructor)
            let seasonForm = computeSeasonForm(driver: driver, standings: driverStandings, fallback: careerForm)
            let circuitHistory = computeCircuitHistoryScore(driver: driver, constructor: constructor, circuitId: circuitId, circuit: circuit)
            let momentum = computeMomentumScore(driver: driver, circuitId: circuitId)
            let qualCircuit = computeQualifyingCircuitScore(driver: driver, circuitId: circuitId)

            let baseScore = careerForm * 0.25 + seasonForm * 0.25 + circuitHistory * 0.25 + momentum * 0.15 + qualCircuit * 0.10
            let totalScore = baseScore

            let factors = buildFactors(career: careerForm, season: seasonForm, circuit: circuitHistory, momentum: momentum, qual: qualCircuit)

            return DriverPrediction(
                id: driver.id,
                driverId: driver.id,
                driverName: driver.fullName,
                driverAbbreviation: driver.abbreviation,
                teamName: constructor?.name ?? teamNameForDriver(driver.id),
                score: totalScore,
                predictedPosition: 0,
                winProbability: totalScore,
                factors: factors,
                reasoning: nil
            )
        }

        let sorted = scored.sorted { $0.score > $1.score }
        let topScores = Array(sorted.prefix(5).map { $0.score })
        let temperature = 10.0
        let expScores = topScores.map { exp($0 * temperature) }
        let sumExp = expScores.reduce(0, +)
        let softmaxProbs = sumExp > 0 ? expScores.map { $0 / sumExp } : Array(repeating: 0, count: topScores.count)

        return Array(sorted.prefix(5).enumerated().map { index, pred in
            let prob = softmaxProbs[index]
            return DriverPrediction(
                id: pred.id,
                driverId: pred.driverId,
                driverName: pred.driverName,
                driverAbbreviation: pred.driverAbbreviation,
                teamName: pred.teamName,
                score: prob * 100,
                predictedPosition: index + 1,
                winProbability: prob,
                factors: pred.factors,
                reasoning: nil
            )
        })
    }

    // MARK: - Scoring

    private func computeCareerForm(driver: F1DBDriver, constructor: F1DBConstructor?) -> Double {
        let winRate = Double(driver.totalRaceWins) / Double(driver.totalRaceEntries)
        let podiumRate = Double(driver.totalPodiums) / Double(driver.totalRaceEntries)
        let poleRate = Double(driver.totalPolePositions) / Double(driver.totalRaceEntries)

        let constructorWinRate: Double
        if let c = constructor, c.totalRaceEntries > 0 {
            constructorWinRate = Double(c.totalRaceWins) / Double(c.totalRaceEntries)
        } else {
            constructorWinRate = 0
        }

        let champScore: Double
        if let best = driver.bestChampionshipPosition {
            champScore = max(0, 1.0 - Double(best - 1) / 22.0)
        } else {
            champScore = 0
        }

        return winRate * 0.30 + podiumRate * 0.25 + poleRate * 0.10 + constructorWinRate * 0.15 + champScore * 0.20
    }

    private func computeSeasonForm(driver: F1DBDriver, standings: [F1DBSeasonDriverStanding], fallback: Double) -> Double {
        guard let standing = standings.first(where: { $0.driverId == driver.id }) else {
            return fallback * 0.6
        }
        let pointsScore = min(1.0, Double(standing.points) / 300.0)
        let positionScore: Double
        if let pos = standing.positionNumber {
            positionScore = max(0, 1.0 - Double(pos - 1) / 22.0)
        } else {
            positionScore = 0.3
        }
        return pointsScore * 0.5 + positionScore * 0.5
    }

    private func computeCircuitHistoryScore(driver: F1DBDriver, constructor: F1DBConstructor?, circuitId: String?, circuit: F1DBCircuit?) -> Double {
        guard let circuitId else { return 0.5 }

        var score = 0.5

        if let avgFinish = f1db.averageFinishForDriver(driverId: driver.id, circuitId: circuitId, maxRaces: 5) {
            let finishScore = max(0, 1.0 - (avgFinish - 1.0) / 20.0)
            score = score * 0.5 + finishScore * 0.5
        }

        if let c = constructor,
           let constFinish = f1db.averageFinishForConstructor(constructorId: c.id, circuitId: circuitId, maxRaces: 5) {
            let constScore = max(0, 1.0 - (constFinish - 1.0) / 20.0)
            score = score * 0.7 + constScore * 0.3
        }

        if let circuit {
            if circuit.type.lowercased() == "street" {
                let streetSpecialists: Set<String> = ["charles-leclerc", "max-verstappen", "lewis-hamilton", "fernando-alonso"]
                if streetSpecialists.contains(driver.id) { score += 0.10 }
            }
        }

        return min(1.0, score)
    }

    private func computeMomentumScore(driver: F1DBDriver, circuitId: String?) -> Double {
        let results = f1db.driverResultsLastRaces(driverId: driver.id, circuitId: nil, limit: 8)
        guard !results.isEmpty else { return 0.4 }

        let weighted: [Double] = results.enumerated().map { i, r in
            let posScore = max(0, 1.0 - Double(r.position - 1) / 20.0)
            let recencyWeight = Double(results.count - i) / Double(results.count)
            return posScore * recencyWeight
        }
        let totalWeight = (1...results.count).map(Double.init).reduce(0, +)
        return weighted.reduce(0, +) / totalWeight
    }

    private func computeQualifyingCircuitScore(driver: F1DBDriver, circuitId: String?) -> Double {
        guard let circuitId else { return computeQualifyingScore(driver: driver) }
        if let avgQuali = f1db.qualifyingPerformanceAtCircuit(driverId: driver.id, circuitId: circuitId, maxRaces: 3) {
            return max(0, 1.0 - (avgQuali - 1.0) / 20.0)
        }
        return computeQualifyingScore(driver: driver)
    }

    private func computeQualifyingScore(driver: F1DBDriver) -> Double {
        let poleRate = Double(driver.totalPolePositions) / Double(driver.totalRaceEntries)
        let gridScore: Double
        if let bestGrid = driver.bestStartingGridPosition {
            gridScore = max(0, 1.0 - Double(bestGrid - 1) / 20.0)
        } else {
            gridScore = 0.3
        }
        return poleRate * 0.5 + gridScore * 0.5
    }

    // MARK: - Factors

    private func buildFactors(career: Double, season: Double, circuit: Double, momentum: Double, qual: Double) -> [PredictionFactor] {
        return [
            PredictionFactor(label: "Career", value: "\(Int(career * 100))%", weight: 0.25),
            PredictionFactor(label: "Season", value: "\(Int(season * 100))%", weight: 0.25),
            PredictionFactor(label: "Circuit", value: "\(Int(circuit * 100))%", weight: 0.25),
            PredictionFactor(label: "Momentum", value: "\(Int(momentum * 100))%", weight: 0.15),
            PredictionFactor(label: "Qualifying", value: "\(Int(qual * 100))%", weight: 0.10),
        ]
    }

    // MARK: - Helpers

    private func buildTeamMap(season: F1DBSeason?) -> [String: String] {
        guard let seasonDrivers = season?.drivers else { return [:] }
        var map: [String: String] = [:]
        for sd in seasonDrivers {
            if let cid = sd.constructorId { map[sd.driverId] = cid }
        }
        return map
    }

    private func filterActiveDrivers(season: F1DBSeason?) -> [F1DBDriver] {
        guard let seasonDrivers = season?.drivers else {
            return f1db.allDrivers().filter { $0.totalRaceEntries > 0 }
        }
        let activeIDs = Set(seasonDrivers.map { $0.driverId })
        return f1db.allDrivers().filter { activeIDs.contains($0.id) }
    }

    private func teamNameForDriver(_ driverId: String) -> String {
        let map: [String: String] = [
            "max-verstappen": "Red Bull", "sergio-perez": "Red Bull",
            "lewis-hamilton": "Ferrari", "charles-leclerc": "Ferrari",
            "george-russell": "Mercedes", "kimi-antonelli": "Mercedes",
            "lando-norris": "McLaren", "oscar-piastri": "McLaren",
            "fernando-alonso": "Aston Martin", "lance-stroll": "Aston Martin",
            "pierre-gasly": "Alpine", "jack-doohan": "Alpine",
            "alexander-albon": "Williams", "carlos-sainz-jr": "Williams",
            "yuki-tsunoda": "Racing Bulls", "liam-lawson": "Red Bull",
            "isack-hadjar": "Racing Bulls", "esteban-ocon": "Haas",
            "oliver-bearman": "Haas", "nico-hulkenberg": "Kick Sauber",
            "gabriel-bortoleto": "Kick Sauber", "jak-crawford": "Racing Bulls",
        ]
        return map[driverId] ?? "Unknown"
    }

    private func driverIdToConstructorID(_ driverId: String) -> String {
        let mapping: [String: String] = [
            "max-verstappen": "red-bull", "sergio-perez": "red-bull",
            "lewis-hamilton": "ferrari", "charles-leclerc": "ferrari",
            "george-russell": "mercedes", "kimi-antonelli": "mercedes",
            "lando-norris": "mclaren", "oscar-piastri": "mclaren",
            "fernando-alonso": "aston-martin", "lance-stroll": "aston-martin",
            "pierre-gasly": "alpine", "jack-doohan": "alpine",
            "alexander-albon": "williams", "carlos-sainz-jr": "williams",
            "yuki-tsunoda": "racing-bulls", "liam-lawson": "red-bull",
            "isack-hadjar": "racing-bulls", "esteban-ocon": "haas",
            "oliver-bearman": "haas", "nico-hulkenberg": "kick-sauber",
            "gabriel-bortoleto": "kick-sauber",
        ]
        return mapping[driverId] ?? driverId
    }

    // MARK: - Fallback drivers (used when F1DB JSON is not loaded)

    private static let fallbackDrivers: [F1DBDriver] = {
        let data: [(id: String, firstName: String, lastName: String, abbr: String)] = [
            ("max-verstappen", "Max", "Verstappen", "VER"),
            ("lewis-hamilton", "Lewis", "Hamilton", "HAM"),
            ("charles-leclerc", "Charles", "Leclerc", "LEC"),
            ("lando-norris", "Lando", "Norris", "NOR"),
            ("oscar-piastri", "Oscar", "Piastri", "PIA"),
            ("george-russell", "George", "Russell", "RUS"),
            ("kimi-antonelli", "Kimi", "Antonelli", "ANT"),
            ("fernando-alonso", "Fernando", "Alonso", "ALO"),
            ("lance-stroll", "Lance", "Stroll", "STR"),
            ("pierre-gasly", "Pierre", "Gasly", "GAS"),
            ("jack-doohan", "Jack", "Doohan", "DOO"),
            ("alexander-albon", "Alexander", "Albon", "ALB"),
            ("carlos-sainz-jr", "Carlos", "Sainz", "SAI"),
            ("yuki-tsunoda", "Yuki", "Tsunoda", "TSU"),
            ("liam-lawson", "Liam", "Lawson", "LAW"),
            ("isack-hadjar", "Isack", "Hadjar", "HAD"),
            ("esteban-ocon", "Esteban", "Ocon", "OCO"),
            ("oliver-bearman", "Oliver", "Bearman", "BEA"),
            ("nico-hulkenberg", "Nico", "Hulkenberg", "HUL"),
            ("gabriel-bortoleto", "Gabriel", "Bortoleto", "BOR"),
            ("sergio-perez", "Sergio", "Perez", "PER"),
            ("jak-crawford", "Jak", "Crawford", "CRA"),
        ]
        let nationalityMap: [String: String] = [
            "max-verstappen": "netherlands", "lewis-hamilton": "united-kingdom",
            "charles-leclerc": "monaco", "lando-norris": "united-kingdom",
            "oscar-piastri": "australia", "george-russell": "united-kingdom",
            "kimi-antonelli": "italy", "fernando-alonso": "spain",
            "lance-stroll": "canada", "pierre-gasly": "france",
            "jack-doohan": "australia", "alexander-albon": "thailand",
            "carlos-sainz-jr": "spain", "yuki-tsunoda": "japan",
            "liam-lawson": "new-zealand", "isack-hadjar": "france",
            "esteban-ocon": "france", "oliver-bearman": "united-kingdom",
            "nico-hulkenberg": "germany", "gabriel-bortoleto": "brazil",
            "sergio-perez": "mexico", "jak-crawford": "united-states",
        ]
        let winsMap: [String: Int] = [
            "max-verstappen": 63, "lewis-hamilton": 105, "fernando-alonso": 32,
            "charles-leclerc": 8, "lando-norris": 5, "oscar-piastri": 2,
            "george-russell": 3, "carlos-sainz-jr": 4, "pierre-gasly": 1,
            "sergio-perez": 6,
        ]
        return data.map { id, first, last, abbr in
            let wins = winsMap[id] ?? 0
            let entries = max(1, wins * 5 + 10)
            let podiums = min(entries, wins * 2 + Int.random(in: 0...5))
            let poles = min(entries, wins + Int.random(in: 0...3))
            return F1DBDriver(
                id: id, name: "\(first) \(last)", firstName: first, lastName: last,
                fullName: "\(first) \(last)", abbreviation: abbr,
                permanentNumber: nil, gender: "Male",
                dateOfBirth: "1990-01-01", dateOfDeath: nil,
                placeOfBirth: "", countryOfBirthCountryId: "",
                nationalityCountryId: nationalityMap[id] ?? "",
                secondNationalityCountryId: nil,
                familyRelationships: nil,
                bestChampionshipPosition: wins > 0 ? Int.random(in: 1...5) : Int.random(in: 6...20),
                bestStartingGridPosition: poles > 0 ? 1 : Int.random(in: 2...10),
                bestRaceResult: wins > 0 ? 1 : Int.random(in: 2...10),
                bestSprintRaceResult: nil,
                totalChampionshipWins: wins > 0 ? (wins > 10 ? Int.random(in: 1...7) : 0) : 0,
                totalRaceEntries: entries, totalRaceStarts: entries,
                totalRaceWins: wins, totalRaceLaps: entries * 50,
                totalPodiums: podiums, totalPoints: Double(wins * 25),
                totalChampionshipPoints: Double(wins * 200),
                totalPolePositions: poles, totalFastestLaps: max(1, wins / 2),
                totalSprintRaceStarts: 10, totalSprintRaceWins: max(0, wins / 5),
                totalDriverOfTheDay: max(1, wins / 3), totalGrandSlams: max(0, wins / 10)
            )
        }
    }()
}
