import Testing
import Foundation

@testable import Formula1

struct LocalizationTests {

    // MARK: - RaceDetail
    @Test func roundFormat() {
        #expect(Strings.RaceDetail.round(5) == "Round 5")
        #expect(Strings.RaceDetail.round(12) == "Round 12")
    }

    @Test func winnerFormat() {
        #expect(Strings.RaceDetail.winner("Verstappen") == "Winner: Verstappen")
    }

    @Test func lapOfFormat() {
        #expect(Strings.RaceDetail.lapOf(42, 78) == "Lap 42 of 78")
    }

    // MARK: - DriverList
    @Test func driverPositionFormat() {
        #expect(Strings.DriverList.position(1) == "P1")
        #expect(Strings.DriverList.position(15) == "P15")
    }

    // MARK: - DriverDetail
    @Test func driverDetailPositionFormat() {
        #expect(Strings.DriverDetail.position(3) == "P3 in standings")
    }

    @Test func driverNumberFormat() {
        #expect(Strings.DriverDetail.driverNumber(44) == "Driver #44")
    }

    @Test func pointsWithPlusFormat() {
        #expect(Strings.DriverDetail.points(25) == "+25 pts")
    }

    // MARK: - ConstructorList
    @Test func constructorWinsFormat() {
        #expect(Strings.ConstructorList.wins(5) == "5 wins")
        #expect(Strings.ConstructorList.win(1) == "1 win")
    }

    // MARK: - ConstructorDetail
    @Test func constructorDetailPositionFormat() {
        #expect(Strings.ConstructorDetail.position(2) == "P2 in standings")
    }

    // MARK: - Podium
    @Test func podiumPositionFormat() {
        #expect(Strings.Podium.position(1) == "#1")
    }

    // MARK: - F1DB
    @Test func f1dbGrandPrixRoundFormat() {
        #expect(Strings.F1DB.GrandPrix.round(25) == "Round 25")
    }

    @Test func f1dbGrandPrixRacesHeldFormat() {
        #expect(Strings.F1DB.GrandPrix.racesHeld(78) == "78 races held")
    }

    @Test func f1dbPitStopsLapFormat() {
        #expect(Strings.F1DB.PitStops.lap(15) == "Lap 15")
    }

    @Test func f1dbFastestLapsLapFormat() {
        #expect(Strings.F1DB.FastestLaps.lap(56) == "Lap 56")
    }

    @Test func f1dbStartingGridPositionFormat() {
        #expect(Strings.F1DB.StartingGrid.position(3) == "P3")
    }

    @Test func f1dbDriverOfTheDayPercentageFormat() {
        #expect(Strings.F1DB.DriverOfTheDay.percentage(25.5) == "25.5% of votes")
    }

    // MARK: - Common
    @Test func commonMoreCountFormat() {
        #expect(Strings.Common.moreCount(5) == "+ 5 more")
    }
}
