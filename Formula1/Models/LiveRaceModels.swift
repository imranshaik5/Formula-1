import Foundation
import SwiftUI

struct LiveRaceSnapshot: Decodable {
    let type: String
    let positions: [LiveDriverPosition]
    let fastestLap: LiveFastestLap?
    let session: LiveSessionState
    let timestamp: TimeInterval
}

struct LiveDriverPosition: Identifiable, Decodable {
    var id: Int { driverNumber }
    let driverNumber: Int
    let position: Int
    let status: String
    let gapToFront: String?
    let intervalToAhead: String?
    let lap: Int
    let lastLapTime: String?
    let sector1: String?
    let sector2: String?
    let sector3: String?
    let speedTrap: String?
    let pitStopCount: Int
    let retired: Bool
}

struct LiveFastestLap: Decodable {
    let driverNumber: Int
    let lap: Int
    let lapTime: String
    let sector1: String?
    let sector2: String?
    let sector3: String?
}

struct LiveSessionState: Decodable {
    let status: String
    let trackStatus: String
    let weather: String
    let airTemp: Double?
    let trackTemp: Double?
    let windSpeed: Double?
    let windDirection: String?
    let humidity: Int?
    let lapCount: Int
    let totalLaps: Int
}

struct LiveSessionStateDefault: Decodable {
    static let `default` = LiveSessionState(
        status: "", trackStatus: "", weather: "",
        airTemp: nil, trackTemp: nil, windSpeed: nil,
        windDirection: nil, humidity: nil,
        lapCount: 0, totalLaps: 0
    )
}

enum TrackStatus: String {
    case green = "1"
    case yellow = "2"
    case safetyCar = "4"
    case red = "5"
    case virtualSafetyCar = "6"

    var displayName: String {
        switch self {
        case .green: return Strings.LiveTiming.greenFlag
        case .yellow: return Strings.LiveTiming.yellowFlag
        case .safetyCar: return Strings.LiveTiming.safetyCar
        case .red: return Strings.LiveTiming.redFlag
        case .virtualSafetyCar: return Strings.LiveTiming.vsc
        }
    }

    var colorValue: Color {
        switch self {
        case .green: return .f1NeonGreen
        case .yellow: return .yellow
        case .safetyCar: return .f1OrangeAccent
        case .red: return .f1Accent
        case .virtualSafetyCar: return .f1OrangeAccent
        }
    }
}
