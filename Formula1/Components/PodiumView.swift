import SwiftUI

struct PodiumView: View {
    let podium: [Driver]
    var onDriverTap: ((Driver) -> Void)?

    var body: some View {
        if podium.isEmpty {
            EmptyView()
        } else {
            let columns = Array(podium.prefix(3))
            let order: [(index: Int, color: Color, glow: Color, height: CGFloat, offset: CGFloat)] = [
                (1, F1Theme.silver, .white.opacity(0.3), 90, 0),
                (0, F1Theme.gold, .yellow.opacity(0.4), 120, -20),
                (2, F1Theme.bronze, .orange.opacity(0.25), 100, 20)
            ]

            HStack(alignment: .bottom, spacing: 6) {
                ForEach(order, id: \.index) { item in
                    if item.index < columns.count {
                        glassPillar(
                            driver: columns[item.index],
                            color: item.color,
                            glow: item.glow,
                            height: item.height,
                            offset: item.offset,
                            position: item.index + 1
                        )
                    }
                }
            }
            .padding(.horizontal, 4)
            .frame(maxWidth: .infinity)
        }
    }

    private func glassPillar(driver: Driver, color: Color, glow: Color, height: CGFloat, offset: CGFloat, position: Int) -> some View {
        VStack(spacing: 8) {
            DriverPhotoView(
                driverName: driver.name,
                teamColor: Color.f1Team(driver.team.name),
                size: position == 1 ? 52 : 44,
                driverCode: driver.code
            )

            Text(driver.name)
                .font(.system(size: position == 1 ? 13 : 11, weight: .semibold))
                .foregroundColor(.white)
                .lineLimit(1)
                .minimumScaleFactor(0.6)
                .frame(width: 80)

            ZStack(alignment: .bottom) {
                RoundedRectangle(cornerRadius: 12)
                    .fill(.ultraThinMaterial)
                    .opacity(0.6)
                    .frame(width: 70, height: height)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(
                                LinearGradient(
                                    colors: [color.opacity(0.8), color.opacity(0.2), color.opacity(0.6)],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ),
                                lineWidth: 1.5
                            )
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(
                                LinearGradient(
                                    colors: [.white.opacity(0.15), .clear, color.opacity(0.1)],
                                    startPoint: .top,
                                    endPoint: .bottom
                                )
                            )
                    )
                    .shadow(color: glow, radius: position == 1 ? 16 : 8, x: 0, y: 0)

                Text(Strings.Podium.position(position))
                    .font(.system(size: position == 1 ? 22 : 16, weight: .bold, design: .rounded))
                    .foregroundColor(color)
                    .shadow(color: glow, radius: position == 1 ? 8 : 4, x: 0, y: 0)
                    .padding(.bottom, 10)
            }
        }
        .offset(y: offset)
        .onTapGesture { onDriverTap?(driver) }
    }
}
