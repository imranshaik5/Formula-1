import SwiftUI

struct RaceResultsTable: View {
    let results: [RaceStatus.RaceResultEntry]
    var onDriverTap: ((Driver) -> Void)?

    var body: some View {
        VStack(spacing: 8) {
            HStack(spacing: 10) {
                Text(Strings.Common.pos)
                    .font(.system(size: 9, weight: .bold, design: .default))
                    .foregroundColor(.white.opacity(0.25))
                    .frame(width: 24, alignment: .leading)

                Text("")
                    .frame(width: 24)

                Text(Strings.Common.driver)
                    .font(.system(size: 9, weight: .bold, design: .default))
                    .foregroundColor(.white.opacity(0.25))

                Spacer()

                Text(Strings.Common.time)
                    .font(.system(size: 9, weight: .bold, design: .default))
                    .foregroundColor(.white.opacity(0.25))
                    .frame(width: 70, alignment: .trailing)

                Text(Strings.Common.pts)
                    .font(.system(size: 9, weight: .bold, design: .default))
                    .foregroundColor(.white.opacity(0.25))
                    .frame(width: 32, alignment: .trailing)
            }
            .padding(.horizontal, 12)

            GlassCard {
                VStack(spacing: 0) {
                    ForEach(Array(results.enumerated()), id: \.element.driver.id) { index, entry in
                        resultRow(index: index, entry: entry, count: results.count)
                    }
                }
            }
            .padding(.horizontal)
        }
    }

    private func resultRow(index: Int, entry: RaceStatus.RaceResultEntry, count: Int) -> some View {
        VStack(spacing: 0) {
            HStack(spacing: 10) {
                positionLabel(index)
                driverThumb(entry)
                driverInfo(entry)
                Spacer()
                timeOrTeam(entry)
                pointsLabel(entry)
            }
            .padding(.vertical, 8)
            .padding(.horizontal, 12)
            .background(index == 0 ? .yellow.opacity(0.04) : .clear)
            .onTapGesture { onDriverTap?(entry.driver) }

            if index < count - 1 {
                Divider().background(.white.opacity(0.04))
            }
        }
    }

    private func positionLabel(_ index: Int) -> some View {
        Text("\(index + 1)")
            .font(.system(size: 12, weight: .bold, design: .monospaced))
            .foregroundColor(index < 3 ? .f1Accent : .white.opacity(0.3))
            .frame(width: 24, alignment: .leading)
    }

    private func driverThumb(_ entry: RaceStatus.RaceResultEntry) -> some View {
        DriverPhotoView(
            driverName: entry.driver.name,
            teamColor: Color.f1Team(entry.driver.team.name),
            size: 24,
            driverCode: entry.driver.code
        )
        .frame(width: 24)
    }

    private func driverInfo(_ entry: RaceStatus.RaceResultEntry) -> some View {
        VStack(alignment: .leading, spacing: 1) {
            Text(entry.driver.name)
                .font(.system(size: 13, weight: .medium))
                .foregroundColor(.white)
                .lineLimit(1)
            Text(entry.driver.team.name)
                .font(.system(size: 9, weight: .regular))
                .foregroundColor(.white.opacity(0.3))
                .lineLimit(1)
        }
    }

    private func timeOrTeam(_ entry: RaceStatus.RaceResultEntry) -> some View {
        Group {
            if let time = entry.time {
                Text(time)
                    .font(.system(size: 11, weight: .regular, design: .monospaced))
                    .foregroundColor(.white.opacity(0.5))
            } else {
                Text(entry.driver.team.id.uppercased())
                    .font(.system(size: 8, weight: .bold, design: .monospaced))
                    .foregroundColor(Color.f1Team(entry.driver.team.name).opacity(0.6))
            }
        }
        .frame(width: 70, alignment: .trailing)
        .lineLimit(1)
        .minimumScaleFactor(0.7)
    }

    private func pointsLabel(_ entry: RaceStatus.RaceResultEntry) -> some View {
        Text("\(entry.points)")
            .font(.system(size: 12, weight: .bold, design: .monospaced))
            .foregroundColor(.white.opacity(0.6))
            .frame(width: 32, alignment: .trailing)
    }
}
