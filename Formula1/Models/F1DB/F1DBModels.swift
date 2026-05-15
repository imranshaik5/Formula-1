import Foundation

struct F1DBRoot: Decodable {
    let drivers: [F1DBDriver]
    let constructors: [F1DBConstructor]
    let engineManufacturers: [F1DBEngineManufacturer]
    let tyreManufacturers: [F1DBTyreManufacturer]
    let entrants: [F1DBEntrant]
    let circuits: [F1DBCircuit]
    let grandsPrix: [F1DBGrandPrix]
    let seasons: [F1DBSeason]
    let races: [F1DBRace]
    let continents: [F1DBContinent]
    let countries: [F1DBCountry]
}

// MARK: - Driver
struct F1DBDriver: Decodable, Identifiable, Hashable {
    let id: String
    let name: String
    let firstName: String
    let lastName: String
    let fullName: String
    let abbreviation: String
    let permanentNumber: String?
    let gender: String
    let dateOfBirth: String
    let dateOfDeath: String?
    let placeOfBirth: String
    let countryOfBirthCountryId: String
    let nationalityCountryId: String
    let secondNationalityCountryId: String?
    let familyRelationships: [F1DBDriverFamilyRelationship]?
    let bestChampionshipPosition: Int?
    let bestStartingGridPosition: Int?
    let bestRaceResult: Int?
    let bestSprintRaceResult: Int?
    let totalChampionshipWins: Int
    let totalRaceEntries: Int
    let totalRaceStarts: Int
    let totalRaceWins: Int
    let totalRaceLaps: Int
    let totalPodiums: Int
    let totalPoints: Double
    let totalChampionshipPoints: Double
    let totalPolePositions: Int
    let totalFastestLaps: Int
    let totalSprintRaceStarts: Int
    let totalSprintRaceWins: Int
    let totalDriverOfTheDay: Int
    let totalGrandSlams: Int
}

struct F1DBDriverFamilyRelationship: Decodable, Hashable {
    let positionDisplayOrder: Int
    let driverId: String
    let type: String
}

// MARK: - Constructor
struct F1DBConstructor: Decodable, Identifiable, Hashable {
    let id: String
    let name: String
    let fullName: String
    let countryId: String
    let chronology: [F1DBConstructorChronology]?
    let bestChampionshipPosition: Int?
    let bestStartingGridPosition: Int?
    let bestRaceResult: Int?
    let bestSprintRaceResult: Int?
    let totalChampionshipWins: Int
    let totalRaceEntries: Int
    let totalRaceStarts: Int
    let totalRaceWins: Int
    let total1And2Finishes: Int
    let totalRaceLaps: Int
    let totalPodiums: Int
    let totalPodiumRaces: Int
    let totalPoints: Double
    let totalChampionshipPoints: Double
    let totalPolePositions: Int
    let totalFastestLaps: Int
    let totalSprintRaceStarts: Int
    let totalSprintRaceWins: Int
}

struct F1DBConstructorChronology: Decodable, Hashable {
    let positionDisplayOrder: Int
    let constructorId: String
    let yearFrom: Int
    let yearTo: Int?
}

// MARK: - Engine & Tyre
struct F1DBEngineManufacturer: Decodable, Identifiable, Hashable {
    let id: String
    let name: String
    let countryId: String
}

struct F1DBTyreManufacturer: Decodable, Identifiable, Hashable {
    let id: String
    let name: String
    let countryId: String
}

struct F1DBEntrant: Decodable, Identifiable, Hashable {
    let id: String
    let name: String
}

// MARK: - Circuit
struct F1DBCircuit: Decodable, Identifiable, Hashable {
    let id: String
    let name: String
    let fullName: String
    let previousNames: [String]?
    let type: String
    let direction: String
    let placeName: String
    let countryId: String
    let latitude: Double
    let longitude: Double
    let length: Double
    let turns: Int
    let layouts: [F1DBCircuitLayout]?
    let totalRacesHeld: Int
}

struct F1DBCircuitLayout: Decodable, Hashable {
    let id: String
    let effective: Bool
    let length: Double
    let turns: Int
}

// MARK: - Grand Prix
struct F1DBGrandPrix: Decodable, Identifiable, Hashable {
    let id: String
    let name: String
    let fullName: String
    let shortName: String
    let abbreviation: String
    let countryId: String?
    let totalRacesHeld: Int
}

// MARK: - Season
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

// MARK: - Race
struct F1DBRace: Decodable, Identifiable, Hashable {
    let id: Int
    let year: Int
    let round: Int
    let date: String
    let time: String?
    let grandPrixId: String
    let officialName: String
    let qualifyingFormat: String?
    let circuitId: String
    let circuitLayoutId: String?
    let circuitType: String
    let direction: String
    let courseLength: Double
    let turns: Int
    let laps: Int
    let distance: Double
    let scheduledLaps: Int?
    let scheduledDistance: Double?
    let qualifyingResults: [F1DBQualifyingResult]?
    let startingGridPositions: [F1DBStartingGridPosition]?
    let raceResults: [F1DBRaceResult]?
    let fastestLaps: [F1DBFastestLap]?
    let pitStops: [F1DBPitStop]?
    let driverOfTheDayResults: [F1DBDriverOfTheDayResult]?
    let driverStandings: [F1DBRaceDriverStanding]?
    let constructorStandings: [F1DBRaceConstructorStanding]?

    static func == (lhs: F1DBRace, rhs: F1DBRace) -> Bool { lhs.id == rhs.id }
    func hash(into hasher: inout Hasher) { hasher.combine(id) }
}

// MARK: - Qualification
struct F1DBQualifyingResult: Decodable, Hashable {
    let positionDisplayOrder: Int
    let positionNumber: Int?
    let positionText: String
    let driverNumber: String?
    let driverId: String
    let constructorId: String
    let engineManufacturerId: String?
    let time: String?
    let timeMillis: Int?
    let q1: String?
    let q1Millis: Int?
    let q2: String?
    let q2Millis: Int?
    let q3: String?
    let q3Millis: Int?
    let laps: Int?
}

// MARK: - Starting Grid
struct F1DBStartingGridPosition: Decodable, Hashable {
    let positionDisplayOrder: Int
    let positionNumber: Int?
    let positionText: String
    let driverNumber: String?
    let driverId: String
    let constructorId: String
    let engineManufacturerId: String?
    let qualificationPositionNumber: Int?
    let gridPenalty: String?
    let gridPenaltyPositions: Int?
    let time: String?
    let timeMillis: Int?
}

// MARK: - Race Result
struct F1DBRaceResult: Decodable, Hashable {
    let positionDisplayOrder: Int
    let positionNumber: Int?
    let positionText: String
    let driverNumber: String?
    let driverId: String
    let constructorId: String
    let engineManufacturerId: String?
    let laps: Int?
    let time: String?
    let timeMillis: Int?
    let timePenalty: String?
    let gap: String?
    let gapLaps: Int?
    let interval: String?
    let reasonRetired: String?
    let points: Int?
    let polePosition: Bool
    let gridPositionNumber: Int?
    let positionsGained: Int?
    let fastestLap: Bool
    let driverOfTheDay: Bool?
    let grandSlam: Bool
}

// MARK: - Fastest Lap
struct F1DBFastestLap: Decodable, Hashable {
    let positionDisplayOrder: Int
    let positionNumber: Int?
    let positionText: String
    let driverNumber: String?
    let driverId: String
    let constructorId: String
    let engineManufacturerId: String?
    let lap: Int?
    let time: String?
    let timeMillis: Int?
    let gap: String?
    let interval: String?
}

// MARK: - Pit Stop
struct F1DBPitStop: Decodable, Hashable {
    let positionDisplayOrder: Int
    let positionNumber: Int?
    let positionText: String
    let driverNumber: String?
    let driverId: String
    let constructorId: String
    let engineManufacturerId: String?
    let stop: Int
    let lap: Int
    let time: String
    let timeMillis: Int?
}

// MARK: - Driver of the Day
struct F1DBDriverOfTheDayResult: Decodable, Hashable {
    let positionDisplayOrder: Int
    let positionNumber: Int?
    let positionText: String
    let driverNumber: String?
    let driverId: String
    let constructorId: String
    let engineManufacturerId: String?
    let percentage: Double?
}

// MARK: - Per-Race Standings
struct F1DBRaceDriverStanding: Decodable, Hashable {
    let positionDisplayOrder: Int
    let positionNumber: Int?
    let positionText: String
    let driverId: String
    let points: Int
    let positionsGained: Int?
}

struct F1DBRaceConstructorStanding: Decodable, Hashable {
    let positionDisplayOrder: Int
    let positionNumber: Int?
    let positionText: String
    let constructorId: String
    let points: Int
    let positionsGained: Int?
}

// MARK: - Geography
struct F1DBContinent: Decodable, Identifiable, Hashable {
    let id: String
    let code: String
    let name: String
    let demonym: String
}

struct F1DBCountry: Decodable, Identifiable, Hashable {
    let id: String
    let alpha2Code: String
    let alpha3Code: String?
    let iocCode: String?
    let name: String
    let demonym: String
    let continentId: String
}
