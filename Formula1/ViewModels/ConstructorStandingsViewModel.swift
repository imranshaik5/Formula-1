import Foundation

@MainActor
final class ConstructorStandingsViewModel: ObservableObject {
    @Published private(set) var standings: [ConstructorStanding] = []
    @Published private(set) var isLoading = false
    @Published private(set) var error: Error?

    private let constructorService: ConstructorServiceProtocol

    init(constructorService: ConstructorServiceProtocol = ConstructorService()) {
        self.constructorService = constructorService
    }

    func loadStandings() async {
        isLoading = true
        error = nil
        do {
            standings = try await constructorService.fetchConstructorStandings()
        } catch {
            self.error = error
        }
        isLoading = false
    }
}
