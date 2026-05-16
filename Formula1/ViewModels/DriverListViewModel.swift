import Foundation

@MainActor
final class DriverListViewModel: ObservableObject {
    @Published var state: LoadState<[Driver]> = .idle

    private let driverService: DriverServiceProtocol

    init(driverService: DriverServiceProtocol = DriverService()) {
        self.driverService = driverService
    }

    func loadDrivers() async {
        state = .loading
        do {
            let drivers = try await driverService.fetchDrivers()
            state = .loaded(drivers)
        } catch {
            state = .error(error)
        }
    }
}
