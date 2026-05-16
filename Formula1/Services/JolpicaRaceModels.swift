import Foundation

// MARK: - Race Schedule
struct JolpicaRaceResponse: Decodable {
    let mrData: MRDataRaceTable

    enum CodingKeys: String, CodingKey {
        case mrData = "MRData"
    }
}

struct MRDataRaceTable: Decodable {
    let total: String
    let raceTable: RaceTable

    enum CodingKeys: String, CodingKey {
        case total
        case raceTable = "RaceTable"
    }
}

struct RaceTable: Decodable {
    let season: String
    let races: [JolpicaRace]

    enum CodingKeys: String, CodingKey {
        case season
        case races = "Races"
    }
}

struct JolpicaRace: Decodable {
    let season: String
    let round: String
    let raceName: String
    let circuit: JolpicaCircuit
    let date: String
    let time: String?

    enum CodingKeys: String, CodingKey {
        case season, round, raceName, date, time
        case circuit = "Circuit"
    }
}

struct JolpicaCircuit: Decodable {
    let circuitId: String
    let circuitName: String
    let location: JolpicaLocation

    enum CodingKeys: String, CodingKey {
        case circuitId
        case circuitName
        case location = "Location"
    }
}

struct JolpicaLocation: Decodable {
    let locality: String
    let country: String
}

// MARK: - Race Results
struct JolpicaRaceResultResponse: Decodable {
    let mrData: MRDataRaceResult

    enum CodingKeys: String, CodingKey {
        case mrData = "MRData"
    }
}

struct MRDataRaceResult: Decodable {
    let raceTable: RaceResultTable

    enum CodingKeys: String, CodingKey {
        case raceTable = "RaceTable"
    }
}

struct RaceResultTable: Decodable {
    let races: [JolpicaRaceWithResult]

    enum CodingKeys: String, CodingKey {
        case races = "Races"
    }
}

struct JolpicaRaceWithResult: Decodable {
    let season: String
    let round: String
    let raceName: String
    let circuit: JolpicaCircuit
    let date: String
    let time: String?
    let results: [JolpicaResult]

    enum CodingKeys: String, CodingKey {
        case season, round, raceName, date, time
        case circuit = "Circuit"
        case results = "Results"
    }
}

struct JolpicaResult: Decodable {
    let position: String
    let driver: JolpicaDriver
    let constructor: JolpicaConstructorSummary
    let status: String
    let time: JolpicaTime?
    let points: String?
    let grid: String?
    let laps: String?
    let fastestLap: JolpicaFastestLap?

    enum CodingKeys: String, CodingKey {
        case position, status, points, grid, laps
        case driver = "Driver"
        case constructor = "Constructor"
        case time = "Time"
        case fastestLap = "FastestLap"
    }
}

struct JolpicaTime: Decodable {
    let millis: String?
    let time: String
}

struct JolpicaFastestLap: Decodable {
    let rank: String
    let lap: String
    let time: JolpicaLapTime?
    let averageSpeed: JolpicaAverageSpeed?

    enum CodingKeys: String, CodingKey {
        case rank, lap
        case time = "Time"
        case averageSpeed = "AverageSpeed"
    }
}

struct JolpicaLapTime: Decodable {
    let time: String
}

struct JolpicaAverageSpeed: Decodable {
    let units: String
    let speed: String
}

// MARK: - Mapping to Domain Models
extension Race {
    init(jolpicaRace: JolpicaRace, roundIndex: Int) {
        let df = ISO8601DateFormatter()
        df.formatOptions = [.withInternetDateTime, .withDashSeparatorInDate, .withColonSeparatorInTime]

        self.id = "\(jolpicaRace.season)-\(jolpicaRace.round)"
        self.round = Int(jolpicaRace.round) ?? 0
        self.name = jolpicaRace.raceName
        self.circuit = Circuit(
            name: jolpicaRace.circuit.circuitName,
            location: jolpicaRace.circuit.location.locality,
            country: jolpicaRace.circuit.location.country
        )

        let dateString: String
        if let time = jolpicaRace.time {
            dateString = "\(jolpicaRace.date)T\(time)"
        } else {
            dateString = "\(jolpicaRace.date)T00:00:00Z"
        }
        self.date = df.date(from: dateString) ?? Date()

        let now = Date()
        let threeHours: TimeInterval = 10800
        if self.date > now {
            self.status = .upcoming
        } else if self.date.addingTimeInterval(threeHours) < now {
            self.status = .completed(nil)
        } else {
            self.status = .live
        }
    }
}

extension Driver {
    init(jolpicaResult: JolpicaResult) {
        let jd = jolpicaResult.driver
        let name = "\(jd.givenName) \(jd.familyName)"
        let teamName = jolpicaResult.constructor.name
        let teamId = jolpicaResult.constructor.constructorId
        self.id = jd.driverId
        self.name = name
        self.code = jd.code ?? ""
        self.number = Int(jd.permanentNumber ?? "0") ?? 0
        self.nationality = jd.nationality
        self.team = Team(id: teamId, name: teamName, color: "#FFFFFF")
        self.points = 0
        self.position = Int(jolpicaResult.position) ?? 0
        self.wins = 0
    }
}
