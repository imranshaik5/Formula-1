import XCTest
import Foundation
@testable import Formula1

final class F1DBModelDecodingTests: XCTestCase {
    let decoder = JSONDecoder()

    func testDecodeDriver() throws {
        let json = """
        {
            "id": "test-driver",
            "name": "Test Driver",
            "firstName": "Test",
            "lastName": "Driver",
            "fullName": "Test Driver",
            "abbreviation": "TES",
            "gender": "Male",
            "dateOfBirth": "1990-01-01",
            "placeOfBirth": "Testville",
            "countryOfBirthCountryId": "test-country",
            "nationalityCountryId": "test-country",
            "totalChampionshipWins": 0,
            "totalRaceEntries": 10,
            "totalRaceStarts": 10,
            "totalRaceWins": 2,
            "totalRaceLaps": 500,
            "totalPodiums": 5,
            "totalPoints": 100,
            "totalChampionshipPoints": 200,
            "totalPolePositions": 1,
            "totalFastestLaps": 1,
            "totalSprintRaceStarts": 0,
            "totalSprintRaceWins": 0,
            "totalDriverOfTheDay": 1,
            "totalGrandSlams": 0
        }
        """
        let driver = try decoder.decode(F1DBDriver.self, from: json.data(using: .utf8)!)
        XCTAssertEqual(driver.id, "test-driver")
        XCTAssertEqual(driver.name, "Test Driver")
        XCTAssertEqual(driver.abbreviation, "TES")
        XCTAssertEqual(driver.totalRaceEntries, 10)
        XCTAssertEqual(driver.totalRaceWins, 2)
        XCTAssertEqual(driver.totalPodiums, 5)
        XCTAssertEqual(driver.totalPoints, 100)
        XCTAssertNil(driver.permanentNumber)
        XCTAssertNil(driver.dateOfDeath)
    }

    func testDecodeConstructor() throws {
        let json = """
        {
            "id": "test-constructor",
            "name": "Test Racing",
            "fullName": "Test Racing",
            "countryId": "test-country",
            "totalChampionshipWins": 1,
            "totalRaceEntries": 100,
            "totalRaceStarts": 100,
            "totalRaceWins": 20,
            "total1And2Finishes": 5,
            "totalRaceLaps": 5000,
            "totalPodiums": 50,
            "totalPodiumRaces": 40,
            "totalPoints": 1000,
            "totalChampionshipPoints": 2000,
            "totalPolePositions": 10,
            "totalFastestLaps": 15,
            "totalSprintRaceStarts": 5,
            "totalSprintRaceWins": 1
        }
        """
        let constructor = try decoder.decode(F1DBConstructor.self, from: json.data(using: .utf8)!)
        XCTAssertEqual(constructor.id, "test-constructor")
        XCTAssertEqual(constructor.name, "Test Racing")
        XCTAssertEqual(constructor.totalRaceWins, 20)
        XCTAssertEqual(constructor.totalChampionshipWins, 1)
        XCTAssertNil(constructor.bestChampionshipPosition)
    }

    func testDecodeCircuit() throws {
        let json = """
        {
            "id": "test-circuit",
            "name": "Test Circuit",
            "fullName": "Test Circuit",
            "type": "race",
            "direction": "clockwise",
            "placeName": "Test Place",
            "countryId": "test-country",
            "latitude": 45.0,
            "longitude": 10.0,
            "length": 5.0,
            "turns": 15,
            "totalRacesHeld": 10
        }
        """
        let circuit = try decoder.decode(F1DBCircuit.self, from: json.data(using: .utf8)!)
        XCTAssertEqual(circuit.id, "test-circuit")
        XCTAssertEqual(circuit.type, "race")
        XCTAssertEqual(circuit.latitude, 45.0)
        XCTAssertEqual(circuit.turns, 15)
        XCTAssertEqual(circuit.totalRacesHeld, 10)
    }

    func testDecodeGrandPrix() throws {
        let json = """
        {
            "id": "test-gp",
            "name": "Test Grand Prix",
            "fullName": "Test Grand Prix",
            "shortName": "Test GP",
            "abbreviation": "TGP",
            "countryId": "test-country",
            "totalRacesHeld": 50
        }
        """
        let gp = try decoder.decode(F1DBGrandPrix.self, from: json.data(using: .utf8)!)
        XCTAssertEqual(gp.id, "test-gp")
        XCTAssertEqual(gp.shortName, "Test GP")
        XCTAssertEqual(gp.totalRacesHeld, 50)
    }

    func testDecodeRace() throws {
        let json = """
        {
            "id": 1,
            "year": 2024,
            "round": 1,
            "date": "2024-03-03",
            "grandPrixId": "test-gp",
            "officialName": "Test Grand Prix",
            "circuitId": "test-circuit",
            "circuitType": "race",
            "direction": "clockwise",
            "courseLength": 5.0,
            "turns": 15,
            "laps": 57,
            "distance": 300.0
        }
        """
        let race = try decoder.decode(F1DBRace.self, from: json.data(using: .utf8)!)
        XCTAssertEqual(race.year, 2024)
        XCTAssertEqual(race.round, 1)
        XCTAssertEqual(race.laps, 57)
    }

    func testDecodeRaceResult() throws {
        let json = """
        {
            "positionDisplayOrder": 1,
            "positionNumber": 1,
            "positionText": "1",
            "driverNumber": "44",
            "driverId": "lewis-hamilton",
            "constructorId": "mercedes",
            "laps": 57,
            "points": 25,
            "polePosition": true,
            "fastestLap": true,
            "grandSlam": false,
            "time": "1:30:00.000"
        }
        """
        let result = try decoder.decode(F1DBRaceResult.self, from: json.data(using: .utf8)!)
        XCTAssertEqual(result.driverId, "lewis-hamilton")
        XCTAssertEqual(result.positionNumber, 1)
        XCTAssertEqual(result.points, 25)
        XCTAssertTrue(result.polePosition)
        XCTAssertTrue(result.fastestLap)
        XCTAssertFalse(result.grandSlam)
    }

    func testDecodeQualifyingResult() throws {
        let json = """
        {
            "positionDisplayOrder": 1,
            "positionNumber": 1,
            "positionText": "1",
            "driverId": "max-verstappen",
            "constructorId": "red-bull",
            "q1": "1:30.000",
            "q2": "1:29.500",
            "q3": "1:28.800",
            "laps": 12
        }
        """
        let quali = try decoder.decode(F1DBQualifyingResult.self, from: json.data(using: .utf8)!)
        XCTAssertEqual(quali.driverId, "max-verstappen")
        XCTAssertEqual(quali.q1, "1:30.000")
        XCTAssertEqual(quali.q3, "1:28.800")
    }

    func testDecodeCountry() throws {
        let json = """
        {
            "id": "test-country",
            "alpha2Code": "TC",
            "name": "Test Country",
            "demonym": "Test",
            "continentId": "test-continent"
        }
        """
        let country = try decoder.decode(F1DBCountry.self, from: json.data(using: .utf8)!)
        XCTAssertEqual(country.id, "test-country")
        XCTAssertEqual(country.name, "Test Country")
        XCTAssertEqual(country.alpha2Code, "TC")
    }

    func testDecodeLoadState() {
        let idle: LoadState<Int> = .idle
        XCTAssertFalse(idle.isLoading)
        XCTAssertNil(idle.value)
        XCTAssertNil(idle.error)

        let loading: LoadState<String> = .loading
        XCTAssertTrue(loading.isLoading)

        let loaded: LoadState<String> = .loaded("test")
        XCTAssertEqual(loaded.value, "test")

        let error = NSError(domain: "test", code: 1)
        let errState: LoadState<Int> = .error(error)
        XCTAssertNotNil(errState.error)
    }

    func testLoadStateEquatable() {
        let a: LoadState<Int> = .idle
        let b: LoadState<Int> = .idle
        XCTAssertEqual(a, b)

        let c: LoadState<Int> = .loaded(5)
        let d: LoadState<Int> = .loaded(5)
        XCTAssertEqual(c, d)

        let e: LoadState<Int> = .loaded(5)
        let f: LoadState<Int> = .loaded(10)
        XCTAssertNotEqual(e, f)
    }
}
