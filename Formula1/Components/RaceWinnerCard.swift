import SwiftUI

struct RaceWinnerCard: View {
    let winner: Driver
    let winnerTime: String?
    var onDriverTap: ((Driver) -> Void)?

    var body: some View {
        VStack(spacing: 12) {
            HStack(spacing: 14) {
                DriverPhotoView(
                    driverName: winner.name,
                    teamColor: Color.f1Team(winner.team.name),
                    size: 52,
                    driverCode: winner.code
                )

                VStack(alignment: .leading, spacing: 2) {
                    Text(Strings.RaceDetail.winnerLabel)
                        .font(.system(size: 9, weight: .bold, design: .default))
                        .foregroundColor(.yellow)
                        .tracking(3)

                    Text(winner.name)
                        .font(.system(size: 18, weight: .bold, design: .default))
                        .foregroundColor(.white)

                    Text(winner.team.name)
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(Color.f1Team(winner.team.name))
                }

                Spacer()
            }

            if let time = winnerTime {
                HStack(spacing: 6) {
                    Image(systemName: "clock.fill")
                        .font(.caption2)
                        .foregroundColor(.yellow.opacity(0.7))
                    Text(time)
                        .font(.system(size: 13, weight: .regular, design: .monospaced))
                        .foregroundColor(.white.opacity(0.7))
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
        .padding(16)
        .background(.ultraThinMaterial)
        .background(Color.f1Card.opacity(0.3))
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(
                    LinearGradient(
                        colors: [.yellow.opacity(0.6), .yellow.opacity(0.1), .yellow.opacity(0.3)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    lineWidth: 1
                )
        )
        .shadow(color: .yellow.opacity(0.08), radius: 20, x: 0, y: 8)
        .padding(.horizontal)
        .onTapGesture { onDriverTap?(winner) }
    }
}
