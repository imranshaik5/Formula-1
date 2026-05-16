import Foundation

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
