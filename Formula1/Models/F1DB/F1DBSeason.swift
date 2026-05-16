import Foundation

struct F1DBSeason: Decodable, Hashable {
    let year: Int
    let entrants: [F1DBSeasonEntrant]?
    let constructors: [F1DBSeasonConstructor]?
    let engineManufacturers: [F1DBSeasonEngineManufacturer]?
    let tyreManufacturers: [F1DBSeasonTyreManufacturer]?
    let drivers: [F1DBSeasonDriver]?
    let driverStandings: [F1DBSeasonDriverStanding]?
    let constructorStandings: [F1DBSeasonConstructorStanding]?
}

struct F1DBSeasonEntrant: Decodable, Hashable {
    let entrantId: String
    let countryId: String
    let constructors: [F1DBSeasonEntrantConstructor]
}

struct F1DBSeasonEntrantConstructor: Decodable, Hashable {
    let constructorId: String
    let engineManufacturerId: String
    let drivers: [F1DBSeasonEntrantDriver]?
}

struct F1DBSeasonEntrantDriver: Decodable, Hashable {
    let driverId: String
    let rounds: [Int]?
    let roundsText: String?
    let testDriver: Bool
}

struct F1DBSeasonConstructor: Decodable, Hashable {
    let year: Int
    let constructorId: String
    let positionNumber: Int?
    let positionText: String?
    let bestStartingGridPosition: Int?
    let bestRaceResult: Int?
    let totalRaceEntries: Int
    let totalRaceStarts: Int
    let totalRaceWins: Int
    let totalRaceLaps: Int
    let totalPodiums: Int
    let totalPoints: Int
    let totalPolePositions: Int
    let totalFastestLaps: Int
}

struct F1DBSeasonEngineManufacturer: Decodable, Hashable {
    let year: Int
    let engineManufacturerId: String
    let positionNumber: Int?
    let positionText: String?
}

struct F1DBSeasonTyreManufacturer: Decodable, Hashable {
    let year: Int
    let tyreManufacturerId: String
}

struct F1DBSeasonDriver: Decodable, Hashable {
    let year: Int
    let driverId: String
    let constructorId: String?
    let positionNumber: Int?
    let positionText: String?
}

struct F1DBSeasonDriverStanding: Decodable, Hashable {
    let year: Int
    let positionDisplayOrder: Int
    let positionNumber: Int?
    let positionText: String
    let driverId: String
    let points: Int
    let championshipWon: Bool?
}

struct F1DBSeasonConstructorStanding: Decodable, Hashable {
    let year: Int
    let positionDisplayOrder: Int
    let positionNumber: Int?
    let positionText: String
    let constructorId: String
    let engineManufacturerId: String?
    let points: Int
    let championshipWon: Bool?
}
