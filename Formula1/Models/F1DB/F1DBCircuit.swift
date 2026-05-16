import Foundation

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
