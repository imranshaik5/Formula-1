import Foundation

struct Race: Identifiable, Hashable {
    let id: String
    let round: Int
    let name: String
    let circuit: Circuit
    let date: Date
    let status: RaceStatus
}

struct Circuit: Hashable {
    let name: String
    let location: String
    let country: String
}

enum RaceStatus: Hashable {
    case upcoming
    case completed(RaceResult?)
    case live

    var isCompleted: Bool {
        if case .completed = self { return true }
        return false
    }

    var isUpcoming: Bool {
        if case .upcoming = self { return true }
        return false
    }

    var isLive: Bool {
        if case .live = self { return true }
        return false
    }

    struct RaceResult: Hashable {
        let winner: Driver
        let podium: [Driver]
        let fullResults: [RaceResultEntry]
        let details: RaceDetails?
    }

    struct RaceResultEntry: Hashable {
        let driver: Driver
        let time: String?
        let points: Int
        let grid: Int
        let laps: Int
    }

    struct RaceDetails: Hashable {
        let fastestLap: FastestLap?
        let totalLaps: Int
    }

    struct FastestLap: Hashable {
        let driver: Driver
        let lap: Int
        let time: String
        let speed: String
    }
}
