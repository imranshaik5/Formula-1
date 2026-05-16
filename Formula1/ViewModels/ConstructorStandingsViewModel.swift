import Foundation

@MainActor
final class ConstructorStandingsViewModel: ObservableObject {
    @Published var state: LoadState<[ConstructorStanding]> = .idle

    private let constructorService: ConstructorServiceProtocol

    init(constructorService: ConstructorServiceProtocol = ConstructorService()) {
        self.constructorService = constructorService
    }

    func loadStandings() async {
        state = .loading
        do {
            let standings = try await constructorService.fetchConstructorStandings()
            state = .loaded(standings)
        } catch {
            state = .error(error)
        }
    }
}
