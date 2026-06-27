import Testing
import Foundation
@testable import Formula1

struct LiveRaceModelsTests {
    @Test func driverPositionDefaults() {
        let pos = LiveDriverPosition(
            driverNumber: 16, position: 1, status: "OnTrack",
            gapToFront: nil, intervalToAhead: nil,
            lap: 10, lastLapTime: nil,
            sector1: nil, sector2: nil, sector3: nil, speedTrap: nil,
            pitStopCount: 0, retired: false
        )
        #expect(pos.driverNumber == 16)
        #expect(pos.position == 1)
        #expect(pos.id == 16)
        #expect(pos.status == "OnTrack")
        #expect(!pos.retired)
    }

    @Test func driverPositionSorting() {
        let p1 = LiveDriverPosition(
            driverNumber: 16, position: 1, status: "OnTrack",
            gapToFront: nil, intervalToAhead: nil,
            lap: 10, lastLapTime: nil,
            sector1: nil, sector2: nil, sector3: nil, speedTrap: nil,
            pitStopCount: 0, retired: false
        )
        let p2 = LiveDriverPosition(
            driverNumber: 55, position: 2, status: "OnTrack",
            gapToFront: "+1.234", intervalToAhead: "+1.234",
            lap: 10, lastLapTime: "1:23.456",
            sector1: "25.5", sector2: "30.2", sector3: "24.1", speedTrap: "310",
            pitStopCount: 0, retired: false
        )
        #expect(p1.position < p2.position)
        #expect(p1.id != p2.id)
    }

    @Test func fastestLapModel() {
        let fl = LiveFastestLap(
            driverNumber: 1, lap: 42, lapTime: "1:23.456",
            sector1: "25.1", sector2: "30.0", sector3: "23.8"
        )
        #expect(fl.driverNumber == 1)
        #expect(fl.lap == 42)
        #expect(fl.lapTime == "1:23.456")
        #expect(fl.sector1 == "25.1")
        #expect(fl.sector2 == "30.0")
        #expect(fl.sector3 == "23.8")
    }

    @Test func sessionStateDefaults() {
        let session = LiveSessionState(
            status: "", trackStatus: "", weather: "",
            airTemp: nil, trackTemp: nil, windSpeed: nil,
            windDirection: nil, humidity: nil,
            lapCount: 0, totalLaps: 0
        )
        #expect(session.status == "")
        #expect(session.lapCount == 0)
        #expect(session.totalLaps == 0)
        #expect(session.airTemp == nil)
    }

    @Test func sessionStateWithData() {
        let session = LiveSessionState(
            status: "InProgress", trackStatus: "1", weather: "Dry",
            airTemp: 24.5, trackTemp: 36.0, windSpeed: 5.2,
            windDirection: "NW", humidity: 45,
            lapCount: 15, totalLaps: 57
        )
        #expect(session.status == "InProgress")
        #expect(session.trackStatus == "1")
        #expect(session.lapCount == 15)
        #expect(session.totalLaps == 57)
        #expect(session.weather == "Dry")
        #expect(session.airTemp == 24.5)
        #expect(session.humidity == 45)
    }

    @Test func trackStatusDisplayNames() {
        #expect(TrackStatus(rawValue: "1")?.displayName == Strings.LiveTiming.greenFlag)
        #expect(TrackStatus(rawValue: "2")?.displayName == Strings.LiveTiming.yellowFlag)
        #expect(TrackStatus(rawValue: "4")?.displayName == Strings.LiveTiming.safetyCar)
        #expect(TrackStatus(rawValue: "5")?.displayName == Strings.LiveTiming.redFlag)
        #expect(TrackStatus(rawValue: "6")?.displayName == Strings.LiveTiming.vsc)
    }

    @Test func trackStatusRawValues() {
        #expect(TrackStatus(rawValue: "1") == .green)
        #expect(TrackStatus(rawValue: "2") == .yellow)
        #expect(TrackStatus(rawValue: "4") == .safetyCar)
        #expect(TrackStatus(rawValue: "5") == .red)
        #expect(TrackStatus(rawValue: "6") == .virtualSafetyCar)
        #expect(TrackStatus(rawValue: "3") == nil)
    }

    @Test func snapshotModel() {
        let session = LiveSessionState(
            status: "InProgress", trackStatus: "1", weather: "Dry",
            airTemp: nil, trackTemp: nil, windSpeed: nil,
            windDirection: nil, humidity: nil,
            lapCount: 1, totalLaps: 57
        )
        let pos = LiveDriverPosition(
            driverNumber: 16, position: 1, status: "OnTrack",
            gapToFront: nil, intervalToAhead: nil,
            lap: 1, lastLapTime: nil,
            sector1: nil, sector2: nil, sector3: nil, speedTrap: nil,
            pitStopCount: 0, retired: false
        )
        let fl = LiveFastestLap(
            driverNumber: 16, lap: 1, lapTime: "1:25.000",
            sector1: nil, sector2: nil, sector3: nil
        )
        let snapshot = LiveRaceSnapshot(
            type: "snapshot", positions: [pos], fastestLap: fl,
            session: session, timestamp: 1000.0
        )
        #expect(snapshot.type == "snapshot")
        #expect(snapshot.positions.count == 1)
        #expect(snapshot.positions[0].driverNumber == 16)
        #expect(snapshot.fastestLap?.lapTime == "1:25.000")
        #expect(snapshot.session.lapCount == 1)
        #expect(snapshot.timestamp == 1000.0)
    }
}
