import SwiftUI

struct RaceFastestLapCard: View {
    let driver: Driver
    let lap: Int
    let totalLaps: Int
    let time: String
    let speed: String
    var onDriverTap: ((Driver) -> Void)?

    var body: some View {
        GlassCard {
            HStack(spacing: 14) {
                DriverPhotoView(
                    driverName: driver.name,
                    teamColor: Color.f1Team(driver.team.name),
                    size: 40,
                    driverCode: driver.code
                )

                VStack(alignment: .leading, spacing: 2) {
                    Text(driver.name)
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(.white)

                    Text(Strings.RaceDetail.lapOf(lap, totalLaps))
                        .font(.system(size: 11, weight: .regular))
                        .foregroundColor(.f1TextSecondary)
                }

                Spacer()

                VStack(alignment: .trailing, spacing: 2) {
                    Text(time)
                        .font(.system(size: 14, weight: .bold, design: .monospaced))
                        .foregroundColor(.f1PurpleAccent)

                    Text("\(speed) kph")
                        .font(.system(size: 10, weight: .regular, design: .monospaced))
                        .foregroundColor(.f1TextSecondary)
                }
            }
        }
        .onTapGesture { onDriverTap?(driver) }
    }
}
