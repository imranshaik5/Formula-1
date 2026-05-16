import Foundation

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
