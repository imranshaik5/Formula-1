import Foundation

// MARK: - Driver Standings
struct JolpicaDriverStandingsResponse: Decodable {
    let mrData: MRDataStandings

    enum CodingKeys: String, CodingKey {
        case mrData = "MRData"
    }
}

struct MRDataStandings: Decodable {
    let total: String
    let standingsTable: StandingsTable

    enum CodingKeys: String, CodingKey {
        case total
        case standingsTable = "StandingsTable"
    }
}

struct StandingsTable: Decodable {
    let season: String
    let standingsLists: [StandingsList]

    enum CodingKeys: String, CodingKey {
        case season
        case standingsLists = "StandingsLists"
    }
}

struct StandingsList: Decodable {
    let season: String
    let round: String
    let driverStandings: [JolpicaDriverStanding]?
    let constructorStandings: [JolpicaConstructorStanding]?

    enum CodingKeys: String, CodingKey {
        case season, round
        case driverStandings = "DriverStandings"
        case constructorStandings = "ConstructorStandings"
    }
}

struct JolpicaDriverStanding: Decodable {
    let position: String
    let points: String
    let wins: String
    let driver: JolpicaDriver
    let constructors: [JolpicaConstructorSummary]

    enum CodingKeys: String, CodingKey {
        case position, points, wins
        case driver = "Driver"
        case constructors = "Constructors"
    }
}

struct JolpicaDriver: Decodable {
    let driverId: String
    let permanentNumber: String?
    let code: String?
    let givenName: String
    let familyName: String
    let nationality: String
}

struct JolpicaConstructorSummary: Decodable {
    let constructorId: String
    let name: String
    let nationality: String
}

// MARK: - Constructor Standings
struct JolpicaConstructorStanding: Decodable {
    let position: String
    let points: String
    let wins: String
    let constructor: JolpicaConstructorSummary

    enum CodingKeys: String, CodingKey {
        case position, points, wins
        case constructor = "Constructor"
    }
}

// MARK: - Mapping to Domain Models
extension Driver {
    init(jolpicaStanding: JolpicaDriverStanding) {
        let jd = jolpicaStanding.driver
        let name = "\(jd.givenName) \(jd.familyName)"
        let teamName = jolpicaStanding.constructors.first?.name ?? "Unknown"
        let teamId = jolpicaStanding.constructors.first?.constructorId ?? "unknown"

        self.id = jd.driverId
        self.name = name
        self.code = jd.code ?? ""
        self.number = Int(jd.permanentNumber ?? "0") ?? 0
        self.nationality = jd.nationality
        self.team = Team(id: teamId, name: teamName, color: "#FFFFFF")
        self.points = Int(jolpicaStanding.points) ?? 0
        self.position = Int(jolpicaStanding.position) ?? 0
        self.wins = Int(jolpicaStanding.wins) ?? 0
    }
}

extension Constructor {
    init(jolpicaSummary: JolpicaConstructorSummary) {
        self.id = jolpicaSummary.constructorId
        self.name = jolpicaSummary.name
        self.nationality = jolpicaSummary.nationality
    }
}

extension ConstructorStanding {
    init(jolpicaStanding: JolpicaConstructorStanding) {
        self.id = jolpicaStanding.constructor.constructorId
        self.position = Int(jolpicaStanding.position) ?? 0
        self.constructor = Constructor(jolpicaSummary: jolpicaStanding.constructor)
        self.points = Int(jolpicaStanding.points) ?? 0
        self.wins = Int(jolpicaStanding.wins) ?? 0
    }
}
