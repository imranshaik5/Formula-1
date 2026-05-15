import Foundation
import SwiftUI

@MainActor
final class ConstructorDetailViewModel: ObservableObject {
    @Published var raceResults: [ConstructorRaceResult] = []
    @Published var isLoading = false

    let standing: ConstructorStanding
    private let constructorService: ConstructorServiceProtocol

    var drivers: [(name: String, points: Int)] {
        let driverPoints = Dictionary(grouping: raceResults.flatMap { $0.driverResults }) {
            $0.driverName
        }.mapValues { results in
            results.reduce(0) { $0 + $1.points }
        }

        let totalPoints = standing.points

        return driverPoints.sorted { $0.value > $1.value }.map { (name, points) in
            (name: name, points: points)
        }
    }

    var totalPoints: Int { standing.points }

    var position: Int { standing.position }

    var wins: Int { standing.wins }

    var teamSlug: String {
        F1Media.teamSlug(for: standing.constructor.name)
    }

    var teamLogoURL: URL {
        F1Media.teamLogoURL(teamSlug: teamSlug)
    }

    var teamColor: Color {
        standing.constructor.color
    }

    init(standing: ConstructorStanding, constructorService: ConstructorServiceProtocol = ConstructorService()) {
        self.standing = standing
        self.constructorService = constructorService
    }

    func loadResults() async {
        isLoading = true
        do {
            let results = try await constructorService.fetchConstructorResults(constructorId: standing.constructor.id)
            raceResults = results
        } catch {
            raceResults = []
        }
        isLoading = false
    }
}