import Foundation

final class LiveRaceViewModel: ObservableObject {
    @Published private(set) var positions: [LiveDriverPosition] = []
    @Published private(set) var fastestLap: LiveFastestLap?
    @Published private(set) var session: LiveSessionState = .init(
        status: "", trackStatus: "", weather: "",
        airTemp: nil, trackTemp: nil, windSpeed: nil,
        windDirection: nil, humidity: nil,
        lapCount: 0, totalLaps: 0
    )
    @Published private(set) var isConnected = false
    @Published private(set) var connectionError: String?

    @Published var driverLookup: [Int: Driver] = [:]
    @Published var driverNumberMapping: [Int: String] = [:]

    private let timingService: LiveTimingServiceProtocol
    private let driverService: DriverServiceProtocol

    init(
        timingService: LiveTimingServiceProtocol = LiveTimingService(),
        driverService: DriverServiceProtocol = DriverService()
    ) {
        self.timingService = timingService
        self.driverService = driverService
        setupBindings()
    }

    private func setupBindings() {
        timingService.onSnapshot = { [weak self] snapshot in
            DispatchQueue.main.async { [weak self] in
                self?.applySnapshot(snapshot)
            }
        }
    }

    func connect() async {
        timingService.connect()
        isConnected = timingService.isConnected
        await loadDriverMapping()
    }

    func disconnect() {
        timingService.disconnect()
        DispatchQueue.main.async { [weak self] in
            self?.isConnected = false
        }
    }

    private func loadDriverMapping() async {
        do {
            let drivers = try await driverService.fetchDrivers()
            var lookup: [Int: Driver] = [:]
            var numberMapping: [Int: String] = [:]
            for driver in drivers {
                lookup[driver.number] = driver
                let name = driver.name
                let parts = name.split(separator: " ")
                let code = driver.code.isEmpty ? String(parts.last?.prefix(3) ?? "") : driver.code
                numberMapping[driver.number] = String(code)
            }
            await MainActor.run {
                driverLookup = lookup
                driverNumberMapping = numberMapping
            }
        } catch {
            print("[LiveRaceVM] Failed to load driver mapping: \(error)")
        }
    }

    private func applySnapshot(_ snapshot: LiveRaceSnapshot) {
        positions = snapshot.positions
            .sorted { $0.position < $1.position }
        fastestLap = snapshot.fastestLap
        session = snapshot.session
        isConnected = true
        connectionError = nil
    }

    func driver(for number: Int) -> Driver? {
        driverLookup[number]
    }

    func shortCode(for number: Int) -> String {
        driverNumberMapping[number] ?? "#\(number)"
    }
}
