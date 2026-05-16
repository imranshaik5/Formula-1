import Foundation

@MainActor
final class RaceDetailViewModel: ObservableObject {
    @Published private(set) var race: Race
    @Published var loadState: LoadState<Void> = .idle

    private let raceService: RaceServiceProtocol

    init(race: Race, raceService: RaceServiceProtocol = RaceService()) {
        self.race = race
        self.raceService = raceService
    }

    func loadRaceDetails() async {
        loadState = .loading
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
            loadState = .loaded(())
        } catch {
            loadState = .error(error)
        }
    }
}
