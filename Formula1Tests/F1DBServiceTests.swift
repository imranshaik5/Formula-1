import XCTest
import Foundation
@testable import Formula1

@MainActor
final class F1DBServiceTests: XCTestCase {
    var service: F1DBService!

    override func setUp() async throws {
        service = F1DBService.shared
        service.ensureLoaded()
        let start = Date()
        while service.isLoading && Date().timeIntervalSince(start) < 10 {
            try await Task.sleep(for: .milliseconds(100))
        }
    }

    func testServiceLazyLoads() {
        XCTAssertFalse(service.isLoading)
        XCTAssertTrue(service.isLoaded)
    }

    func testDriverQueryReturnsNilForUnknownID() {
        let driver = service.driver(id: "nonexistent-driver")
        XCTAssertNil(driver)
    }

    func testConstructorQueryReturnsNilForUnknownID() {
        let c = service.constructor(id: "nonexistent")
        XCTAssertNil(c)
    }

    func testCircuitQueryReturnsNilForUnknownID() {
        let c = service.circuit(id: "nonexistent")
        XCTAssertNil(c)
    }

    func testGrandPrixQueryReturnsNilForUnknownID() {
        let gp = service.grandPrix(id: "nonexistent")
        XCTAssertNil(gp)
    }

    func testCountryQueryReturnsNilForUnknownID() {
        let c = service.country(id: "nonexistent")
        XCTAssertNil(c)
    }

    func testRaceQueryReturnsNilForUnknownYearAndRound() {
        let race = service.race(year: 1999, round: 99)
        XCTAssertNil(race)
    }

    func testRacesForYearReturnsEmptyForUnknownYear() {
        let races = service.racesFor(year: 1900)
        XCTAssertTrue(races.isEmpty)
    }

    func testRacesAtCircuitReturnsEmptyForUnknownCircuit() {
        let races = service.racesAtCircuit(circuitId: "unknown")
        XCTAssertTrue(races.isEmpty)
    }

    func testAllDriversReturnsList() {
        let drivers = service.allDrivers()
        XCTAssertNotNil(drivers)
    }

    func testAllConstructorsReturnsList() {
        let constructors = service.allConstructors()
        XCTAssertNotNil(constructors)
    }

    func testCountryNameReturnsIdForUnknown() {
        let name = service.countryName(id: "unknown-country")
        XCTAssertEqual(name, "unknown-country")
    }

    func testAverageFinishReturnsNilForUnknownDriver() {
        let avg = service.averageFinishForDriver(driverId: "nonexistent", circuitId: "test-circuit")
        XCTAssertNil(avg)
    }

    func testAverageFinishForConstructorReturnsNilForUnknown() {
        let avg = service.averageFinishForConstructor(constructorId: "nonexistent", circuitId: "test-circuit")
        XCTAssertNil(avg)
    }

    func testDriverResultsLastRacesReturnsEmptyForUnknownDriver() {
        let results = service.driverResultsLastRaces(driverId: "nonexistent")
        XCTAssertTrue(results.isEmpty)
    }

    func testQualifyingPerformanceReturnsNilForUnknownDriver() {
        let qp = service.qualifyingPerformanceAtCircuit(driverId: "nonexistent", circuitId: "test-circuit")
        XCTAssertNil(qp)
    }
}
