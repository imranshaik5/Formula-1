import SwiftUI

struct RaceDetailsCard: View {
    let totalLaps: Int
    let winnerTime: String?
    let finishers: Int
    let classified: Int
    let fastestLap: (driverName: String, time: String, speed: String)?

    var body: some View {
        GlassCard {
            VStack(spacing: 12) {
                detailRow(label: "Total Laps", value: "\(totalLaps)")
                if let winnerTime {
                    detailRow(label: "Race Time", value: winnerTime)
                }
                detailRow(label: "Finishers", value: "\(finishers)")
                detailRow(label: "Classified", value: "\(classified)")

                if let fl = fastestLap {
                    Divider().background(.white.opacity(0.06))
                    detailRow(label: Strings.RaceDetail.fastestLapLabel, value: fl.driverName)
                    detailRow(label: "Fastest Lap Time", value: fl.time)
                    detailRow(label: "Avg Speed", value: "\(fl.speed) kph")
                }
            }
        }
    }

    private func detailRow(label: String, value: String) -> some View {
        HStack {
            Text(label)
                .font(F1Theme.subheadline)
                .foregroundColor(.f1TextSecondary)
            Spacer()
            Text(value)
                .font(F1Theme.subheadline)
                .foregroundColor(.white)
        }
    }
}
