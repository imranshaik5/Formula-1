import XCTest
import Foundation
@testable import Formula1

final class MockTimingService: LiveTimingServiceProtocol {
    var onSnapshot: ((LiveRaceSnapshot) -> Void)?
    private(set) var isConnected = false
    var connectCallCount = 0
    var disconnectCallCount = 0
    var stubbedSnapshot: LiveRaceSnapshot?

    func connect() {
        connectCallCount += 1
        isConnected = true
        if let snapshot = stubbedSnapshot {
            onSnapshot?(snapshot)
        }
    }

    func disconnect() {
        disconnectCallCount += 1
        isConnected = false
    }
}

final class MockDriverService: DriverServiceProtocol {
    var stubbedDrivers: [Driver] = []
    var fetchCallCount = 0

    func fetchDrivers() async throws -> [Driver] {
        fetchCallCount += 1
        return stubbedDrivers
    }

    func fetchDriver(by id: String) async throws -> Driver? { nil }
    func fetchDriverResults(driverId: String) async throws -> [RaceStatus.RaceResultEntry] { [] }
}

final class LiveRaceViewModelTests: XCTestCase {
    var timingService: MockTimingService!
    var driverService: MockDriverService!
    var viewModel: LiveRaceViewModel!

    override func setUp() {
        timingService = MockTimingService()
        driverService = MockDriverService()
        viewModel = LiveRaceViewModel(
            timingService: timingService,
            driverService: driverService
        )
    }

    override func tearDown() {
        viewModel = nil
        timingService = nil
        driverService = nil
    }

    func testInitialState() {
        XCTAssertTrue(viewModel.positions.isEmpty)
        XCTAssertNil(viewModel.fastestLap)
        XCTAssertEqual(viewModel.session.lapCount, 0)
        XCTAssertFalse(viewModel.isConnected)
        XCTAssertNil(viewModel.connectionError)
    }

    func testConnectDelegatesToService() async {
        await viewModel.connect()
        XCTAssertEqual(timingService.connectCallCount, 1)
    }

    func testConnectUpdatesIsConnected() async {
        await viewModel.connect()
        XCTAssertTrue(viewModel.isConnected)
    }

    func testDisconnectDelegatesToService() async {
        await viewModel.connect()
        viewModel.disconnect()
        XCTAssertEqual(timingService.disconnectCallCount, 1)
        let exp = expectation(description: "main queue")
        DispatchQueue.main.async {
            XCTAssertFalse(self.viewModel.isConnected)
            exp.fulfill()
        }
        await fulfillment(of: [exp], timeout: 0.5)
    }

    func testSnapshotUpdatesPositions() {
        let pos = LiveDriverPosition(
            driverNumber: 16, position: 1, status: "OnTrack",
            gapToFront: nil, intervalToAhead: nil,
            lap: 1, lastLapTime: nil,
            sector1: nil, sector2: nil, sector3: nil, speedTrap: nil,
            pitStopCount: 0, retired: false
        )
        let snapshot = LiveRaceSnapshot(
            type: "snapshot", positions: [pos], fastestLap: nil,
            session: .init(status: "", trackStatus: "", weather: "",
                           airTemp: nil, trackTemp: nil, windSpeed: nil,
                           windDirection: nil, humidity: nil,
                           lapCount: 5, totalLaps: 57),
            timestamp: 1000
        )
        timingService.stubbedSnapshot = snapshot
        timingService.connect()

        let exp = expectation(description: "Positions updated")
        DispatchQueue.main.async {
            XCTAssertEqual(self.viewModel.positions.count, 1)
            XCTAssertEqual(self.viewModel.positions[0].driverNumber, 16)
            XCTAssertEqual(self.viewModel.session.lapCount, 5)
            XCTAssertTrue(self.viewModel.isConnected)
            XCTAssertNil(self.viewModel.connectionError)
            exp.fulfill()
        }
        wait(for: [exp], timeout: 0.5)
    }

    func testSnapshotWithFastestLap() {
        let fl = LiveFastestLap(
            driverNumber: 1, lap: 42, lapTime: "1:23.456",
            sector1: nil, sector2: nil, sector3: nil
        )
        let pos = LiveDriverPosition(
            driverNumber: 1, position: 1, status: "OnTrack",
            gapToFront: nil, intervalToAhead: nil,
            lap: 42, lastLapTime: "1:23.456",
            sector1: nil, sector2: nil, sector3: nil, speedTrap: nil,
            pitStopCount: 0, retired: false
        )
        let snapshot = LiveRaceSnapshot(
            type: "snapshot", positions: [pos], fastestLap: fl,
            session: .init(status: "", trackStatus: "", weather: "",
                           airTemp: nil, trackTemp: nil, windSpeed: nil,
                           windDirection: nil, humidity: nil,
                           lapCount: 42, totalLaps: 57),
            timestamp: 1000
        )
        timingService.stubbedSnapshot = snapshot
        timingService.connect()

        let exp = expectation(description: "Fastest lap updated")
        DispatchQueue.main.async {
            XCTAssertNotNil(self.viewModel.fastestLap)
            XCTAssertEqual(self.viewModel.fastestLap?.driverNumber, 1)
            XCTAssertEqual(self.viewModel.fastestLap?.lapTime, "1:23.456")
            exp.fulfill()
        }
        wait(for: [exp], timeout: 0.5)
    }

    func testPositionsAreSortedByPosition() {
        let p2 = LiveDriverPosition(
            driverNumber: 55, position: 2, status: "OnTrack",
            gapToFront: nil, intervalToAhead: nil,
            lap: 1, lastLapTime: nil,
            sector1: nil, sector2: nil, sector3: nil, speedTrap: nil,
            pitStopCount: 0, retired: false
        )
        let p1 = LiveDriverPosition(
            driverNumber: 16, position: 1, status: "OnTrack",
            gapToFront: nil, intervalToAhead: nil,
            lap: 1, lastLapTime: nil,
            sector1: nil, sector2: nil, sector3: nil, speedTrap: nil,
            pitStopCount: 0, retired: false
        )
        let snapshot = LiveRaceSnapshot(
            type: "snapshot", positions: [p2, p1], fastestLap: nil,
            session: .init(status: "", trackStatus: "", weather: "",
                           airTemp: nil, trackTemp: nil, windSpeed: nil,
                           windDirection: nil, humidity: nil,
            lapCount: 1, totalLaps: 57),
            timestamp: 1000
        )
        timingService.stubbedSnapshot = snapshot
        timingService.connect()

        let exp = expectation(description: "Positions sorted")
        DispatchQueue.main.async {
            XCTAssertEqual(self.viewModel.positions.count, 2)
            XCTAssertEqual(self.viewModel.positions[0].position, 1)
            XCTAssertEqual(self.viewModel.positions[0].driverNumber, 16)
            XCTAssertEqual(self.viewModel.positions[1].position, 2)
            XCTAssertEqual(self.viewModel.positions[1].driverNumber, 55)
            exp.fulfill()
        }
        wait(for: [exp], timeout: 0.5)
    }

    func testDriverLookupAfterConnect() async {
        let team = Team(id: "ferrari", name: "Ferrari", color: "#DC0000")
        let driver = Driver(
            id: "leclerc", name: "Charles Leclerc", code: "LEC",
            number: 16, nationality: "Monegasque",
            team: team, points: 75, position: 4, wins: 0
        )
        driverService.stubbedDrivers = [driver]
        await viewModel.connect()

        XCTAssertEqual(driverService.fetchCallCount, 1)
        XCTAssertEqual(viewModel.driverLookup.count, 1)
        XCTAssertEqual(viewModel.driverLookup[16]?.name, "Charles Leclerc")
        XCTAssertEqual(viewModel.shortCode(for: 16), "LEC")
        XCTAssertEqual(viewModel.driver(for: 16)?.name, "Charles Leclerc")
    }

    func testShortCodeForUnknownDriver() {
        XCTAssertEqual(viewModel.shortCode(for: 99), "#99")
    }

    func testDriverForUnknownNumber() {
        XCTAssertNil(viewModel.driver(for: 99))
    }
}
