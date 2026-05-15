import Foundation

final class ConstructorService: ConstructorServiceProtocol {
    private let apiClient: APIClient

    init(apiClient: APIClient = APIClient()) {
        self.apiClient = apiClient
    }

    func fetchConstructorStandings() async throws -> [ConstructorStanding] {
        let response: JolpicaDriverStandingsResponse = try await apiClient.fetch("current/constructorStandings")
        guard let standingsList = response.mrData.standingsTable.standingsLists.first,
              let standings = standingsList.constructorStandings else {
            return []
        }
        return standings.map(ConstructorStanding.init(jolpicaStanding:))
    }
}
