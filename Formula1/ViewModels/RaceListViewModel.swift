import Foundation

@MainActor
final class RaceListViewModel: ObservableObject {
    @Published var state: LoadState<[Race]> = .idle

    private let raceService: RaceServiceProtocol

    init(raceService: RaceServiceProtocol = RaceService()) {
        self.raceService = raceService
    }

    func loadRaces() async {
        state = .loading
        do {
            let races = try await raceService.fetchRaces()
            state = .loaded(races)
        } catch {
            state = .error(error)
        }
    }
}
