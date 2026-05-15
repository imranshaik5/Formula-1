import SwiftUI

struct Constructor: Identifiable, Hashable {
    let id: String
    let name: String
    let nationality: String
}

extension Constructor {
    var color: Color {
        F1TeamColor.forTeam(name)
    }
}
