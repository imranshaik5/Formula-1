import Foundation

final class MockLiveTimingService: LiveTimingServiceProtocol {
    var onSnapshot: ((LiveRaceSnapshot) -> Void)?
    var isConnected: Bool { _isActive }

    private var _isActive = false
    private var cycle = 0
    private var timer: Timer?

    private struct MockDriver {
        let number: Int
        let code: String
    }

    private let drivers: [MockDriver] = [
        .init(number: 16, code: "LEC"), .init(number: 55, code: "SAI"),
        .init(number: 1, code: "VER"), .init(number: 11, code: "PER"),
        .init(number: 4, code: "NOR"), .init(number: 81, code: "PIA"),
        .init(number: 44, code: "HAM"), .init(number: 63, code: "RUS"),
        .init(number: 14, code: "ALO"), .init(number: 18, code: "STR"),
        .init(number: 10, code: "GAS"), .init(number: 31, code: "OCO"),
        .init(number: 22, code: "TSU"), .init(number: 3, code: "RIC"),
        .init(number: 23, code: "ALB"), .init(number: 2, code: "SAR"),
        .init(number: 27, code: "HUL"), .init(number: 20, code: "MAG"),
        .init(number: 24, code: "ZHO"), .init(number: 77, code: "BOT"),
    ]

    func connect() {
        guard !_isActive else { return }
        _isActive = true
        generateSnapshot()
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            self?.generateSnapshot()
        }
    }

    func disconnect() {
        _isActive = false
        timer?.invalidate()
        timer = nil
    }

    private func generateSnapshot() {
        cycle += 1
        let cyc = cycle

        let baseLap: Double = 85.0
        var rawTimes: [Int: Double] = [:]

        for (i, driver) in drivers.enumerated() {
            let variation = Double.random(in: -0.75...0.75)
            let perf = sin(Double(cyc) * 0.05 + Double(i) * 0.7) * 0.15
            rawTimes[driver.number] = max(72.0, baseLap + variation + perf)
        }

        let sorted = rawTimes.keys.sorted { rawTimes[$0]! < rawTimes[$1]! }

        var positions: [LiveDriverPosition] = []
        var bestTime = Double.infinity
        var bestDn = 0
        var leaderGap: Double = 0

        let trackFlags = ["1", "1", "1", "1", "1", "2", "1", "1", "1", "1"]
        let trackIdx = (cyc / 30) % trackFlags.count

        for (pos, dn) in sorted.enumerated() {
            let gapToFront = rawTimes[dn]! - rawTimes[sorted[0]]!
            let interval = pos > 0 ? gapToFront - leaderGap : 0.0
            leaderGap = gapToFront
            let lap = max(1, min(57, Int(Double(cyc) * 0.3)))

            let s1 = Double.random(in: 25.0...28.0)
            let s2 = Double.random(in: 30.0...34.0)
            let s3 = Double.random(in: 23.0...26.0)
            let lapTime = s1 + s2 + s3

            if lapTime < bestTime {
                bestTime = lapTime
                bestDn = dn
            }

            func fmt(_ t: Double) -> String {
                let m = Int(t) / 60
                let s = t - Double(m * 60)
                return "\(m):\(String(format: "%06.3f", s))"
            }

            func gapStr(_ g: Double) -> String {
                if g <= 0 { return "\u{2014}" }
                if g >= 60 {
                    let mins = Int(g) / 60
                    let secs = g - Double(mins * 60)
                    return "+\(mins):\(String(format: "%05.2f", secs))"
                }
                return "+\(String(format: "%06.3f", g))"
            }

            positions.append(LiveDriverPosition(
                driverNumber: dn,
                position: pos + 1,
                status: Int.random(in: 0..<5) < 4 ? "OnTrack" : "Pit",
                gapToFront: gapStr(gapToFront),
                intervalToAhead: gapStr(interval),
                lap: lap,
                lastLapTime: fmt(lapTime),
                sector1: fmt(s1),
                sector2: fmt(s2),
                sector3: fmt(s3),
                speedTrap: "\(Int.random(in: 290...340))",
                pitStopCount: cyc > 20 ? [0, 0, 0, 1, 0, 0, 2].randomElement()! : 0,
                retired: false
            ))
        }

        let bestPos = positions.first { $0.driverNumber == bestDn }
        let fastestLap = bestPos.map { pos in
            LiveFastestLap(
                driverNumber: bestDn,
                lap: pos.lap,
                lapTime: pos.lastLapTime ?? "",
                sector1: pos.sector1,
                sector2: pos.sector2,
                sector3: pos.sector3
            )
        }

        let currentLap = max(1, min(57, Int(Double(cyc) * 0.3)))

        let session = LiveSessionState(
            status: "InProgress",
            trackStatus: trackFlags[trackIdx],
            weather: "Dry",
            airTemp: (24.0 + sin(Double(cyc) * 0.02) * 3).rounded(),
            trackTemp: (36.0 + sin(Double(cyc) * 0.015) * 4).rounded(),
            windSpeed: Double.random(in: 2.0...8.0).rounded(),
            windDirection: ["N", "NE", "E", "SE", "S", "SW", "W", "NW"].randomElement()!,
            humidity: Int.random(in: 30...60),
            lapCount: currentLap,
            totalLaps: 57
        )

        let snapshot = LiveRaceSnapshot(
            type: "snapshot",
            positions: positions,
            fastestLap: fastestLap,
            session: session,
            timestamp: Date().timeIntervalSince1970
        )

        onSnapshot?(snapshot)
    }
}
