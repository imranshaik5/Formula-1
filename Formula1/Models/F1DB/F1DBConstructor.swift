import Foundation

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
