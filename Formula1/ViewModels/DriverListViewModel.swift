import Foundation

@MainActor
final class DriverListViewModel: ObservableObject {
    @Published private(set) var drivers: [Driver] = []
    @Published private(set) var isLoading = false
    @Published private(set) var error: Error?

    private let driverService: DriverServiceProtocol

    init(driverService: DriverServiceProtocol = DriverService()) {
        self.driverService = driverService
    }

    func loadDrivers() async {
        isLoading = true
        error = nil
        do {
            drivers = try await driverService.fetchDrivers()
        } catch {
            self.error = error
        }
        isLoading = false
    }
}
