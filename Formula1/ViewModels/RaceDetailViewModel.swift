import Foundation

@MainActor
final class RaceDetailViewModel: ObservableObject {
    @Published private(set) var race: Race
    @Published private(set) var isLoading = false
    @Published private(set) var error: Error?

    private let raceService: RaceServiceProtocol

    init(race: Race, raceService: RaceServiceProtocol = RaceService()) {
        self.race = race
        self.raceService = raceService
    }

    func loadRaceDetails() async {
        isLoading = true
        error = nil
        do {
            if let updated = try await raceService.fetchRace(by: race.id) {
                race = updated
            }
            if race.status.isCompleted {
                let result = try await raceService.fetchRaceResults(round: race.round)
                if let result {
                    race = Race(
                        id: race.id,
                        round: race.round,
                        name: race.name,
                        circuit: race.circuit,
                        date: race.date,
                        status: .completed(result)
                    )
                }
            }
        } catch {
            self.error = error
        }
        isLoading = false
    }
}
