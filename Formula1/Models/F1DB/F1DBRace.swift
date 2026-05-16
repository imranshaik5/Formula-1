import Foundation

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
