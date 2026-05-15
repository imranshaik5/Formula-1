import Foundation

struct Driver: Identifiable, Hashable {
    let id: String
    let name: String
    let code: String
    let number: Int
    let nationality: String
    let team: Team
    let points: Int
    let position: Int
    let wins: Int
}

struct Team: Hashable {
    let id: String
    let name: String
    let color: String
}
