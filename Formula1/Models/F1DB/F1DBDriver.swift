import Foundation

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
