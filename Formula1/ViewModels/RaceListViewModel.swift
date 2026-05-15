import Foundation

@MainActor
final class RaceListViewModel: ObservableObject {
    @Published private(set) var races: [Race] = []
    @Published private(set) var isLoading = false
    @Published private(set) var error: Error?

    private let raceService: RaceServiceProtocol

    init(raceService: RaceServiceProtocol = RaceService()) {
        self.raceService = raceService
    }

    func loadRaces() async {
        isLoading = true
        error = nil
        do {
            races = try await raceService.fetchRaces()
        } catch {
            self.error = error
        }
        isLoading = false
    }
}
