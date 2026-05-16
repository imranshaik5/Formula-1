import Foundation

struct F1DBGrandPrix: Decodable, Identifiable, Hashable {
    let id: String
    let name: String
    let fullName: String
    let shortName: String
    let abbreviation: String
    let countryId: String?
    let totalRacesHeld: Int
}
