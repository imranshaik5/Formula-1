import XCTest
import Foundation
@testable import Formula1

final class MockLiveTimingServiceTests: XCTestCase {
    var service: MockLiveTimingService!

    override func setUp() {
        service = MockLiveTimingService()
    }

    override func tearDown() {
        service.disconnect()
        service = nil
    }

    func testInitialStateIsDisconnected() {
        XCTAssertFalse(service.isConnected)
    }

    func testConnectingSetsConnected() {
        service.connect()
        XCTAssertTrue(service.isConnected)
    }

    func testDisconnectingSetsDisconnected() {
        service.connect()
        service.disconnect()
        XCTAssertFalse(service.isConnected)
    }

    func testDoubleConnectIsIdempotent() {
        service.connect()
        service.connect()
        XCTAssertTrue(service.isConnected)
    }

    func testSnapshotCallbackIsCalled() {
        let expectation = expectation(description: "Snapshot callback")
        service.onSnapshot = { snapshot in
            expectation.fulfill()
        }
        service.connect()
        wait(for: [expectation], timeout: 3.0)
    }

    func testGeneratedSnapshotHas20Drivers() {
        let expectation = expectation(description: "Snapshot received")
        service.onSnapshot = { snapshot in
            XCTAssertEqual(snapshot.positions.count, 20)
            expectation.fulfill()
        }
        service.connect()
        wait(for: [expectation], timeout: 3.0)
    }

    func testGeneratedPositionsAreSequential() {
        let expectation = expectation(description: "Snapshot received")
        service.onSnapshot = { snapshot in
            let sorted = snapshot.positions.sorted { $0.position < $1.position }
            for (i, pos) in sorted.enumerated() {
                XCTAssertEqual(pos.position, i + 1)
            }
            expectation.fulfill()
        }
        service.connect()
        wait(for: [expectation], timeout: 3.0)
    }

    func testNoDuplicateDriverNumbers() {
        let expectation = expectation(description: "Snapshot received")
        service.onSnapshot = { snapshot in
            let numbers = snapshot.positions.map { $0.driverNumber }
            let unique = Set(numbers)
            XCTAssertEqual(numbers.count, unique.count)
            expectation.fulfill()
        }
        service.connect()
        wait(for: [expectation], timeout: 3.0)
    }

    func testFastestLapIsOneOfDrivers() {
        let expectation = expectation(description: "Snapshot received")
        service.onSnapshot = { snapshot in
            guard let fl = snapshot.fastestLap else {
                XCTFail("No fastest lap")
                return
            }
            let numbers = snapshot.positions.map { $0.driverNumber }
            XCTAssertTrue(numbers.contains(fl.driverNumber))
            expectation.fulfill()
        }
        service.connect()
        wait(for: [expectation], timeout: 3.0)
    }

    func testSessionStateIsPopulated() {
        let expectation = expectation(description: "Snapshot received")
        service.onSnapshot = { snapshot in
            let s = snapshot.session
            XCTAssertEqual(s.status, "InProgress")
            XCTAssertEqual(s.weather, "Dry")
            XCTAssertGreaterThan(s.totalLaps, 0)
            XCTAssertNotNil(s.airTemp)
            XCTAssertNotNil(s.trackTemp)
            expectation.fulfill()
        }
        service.connect()
        wait(for: [expectation], timeout: 3.0)
    }

    func testMultipleSnapshotsAreGenerated() {
        var count = 0
        let expectation = expectation(description: "Multiple snapshots")
        expectation.expectedFulfillmentCount = 3
        service.onSnapshot = { snapshot in
            count += 1
            expectation.fulfill()
        }
        service.connect()
        wait(for: [expectation], timeout: 5.0)
        XCTAssertEqual(count, 3)
    }

    func testNoCallbacksAfterDisconnect() {
        let received = expectation(description: "First snapshot")
        service.onSnapshot = { snapshot in
            received.fulfill()
            self.service.disconnect()
        }
        service.connect()
        wait(for: [received], timeout: 3.0)

        let unexpectedFire = expectation(description: "Unexpected callback")
        unexpectedFire.isInverted = true
        service.onSnapshot = { snapshot in
            unexpectedFire.fulfill()
        }
        wait(for: [unexpectedFire], timeout: 2.0)
    }
}
