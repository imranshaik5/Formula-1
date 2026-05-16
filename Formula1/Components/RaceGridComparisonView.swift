import SwiftUI

struct RaceGridComparisonView: View {
    let results: [RaceStatus.RaceResultEntry]

    var body: some View {
        GlassCard {
            VStack(spacing: 0) {
                HStack(spacing: 10) {
                    Text(Strings.Common.start)
                        .font(.system(size: 9, weight: .bold, design: .default))
                        .foregroundColor(.white.opacity(0.25))
                        .frame(width: 36, alignment: .leading)

                    Text(Strings.Common.driver)
                        .font(.system(size: 9, weight: .bold, design: .default))
                        .foregroundColor(.white.opacity(0.25))

                    Spacer()

                    Text(Strings.Common.finish)
                        .font(.system(size: 9, weight: .bold, design: .default))
                        .foregroundColor(.white.opacity(0.25))
                        .frame(width: 36, alignment: .trailing)

                    Text("+/–")
                        .font(.system(size: 9, weight: .bold, design: .default))
                        .foregroundColor(.white.opacity(0.25))
                        .frame(width: 28, alignment: .trailing)
                }
                .padding(.bottom, 8)

                ForEach(Array(results.prefix(10).enumerated()), id: \.element.driver.id) { _, entry in
                    gridRow(entry)
                }
            }
        }
    }

    private func gridRow(_ entry: RaceStatus.RaceResultEntry) -> some View {
        VStack(spacing: 0) {
            HStack(spacing: 10) {
                gridStartCell(entry)
                gridDriverCell(entry)
                Spacer()
                gridFinishCell(entry)
                gridDeltaCell(entry)
            }
            .padding(.vertical, 6)

            Divider().background(.white.opacity(0.03))
        }
    }

    private func gridStartCell(_ entry: RaceStatus.RaceResultEntry) -> some View {
        Text(Strings.DriverDetail.positionP(entry.grid))
            .font(.system(size: 11, weight: .medium, design: .monospaced))
            .foregroundColor(.white.opacity(0.5))
            .frame(width: 36, alignment: .leading)
    }

    private func gridDriverCell(_ entry: RaceStatus.RaceResultEntry) -> some View {
        HStack(spacing: 6) {
            DriverPhotoView(
                driverName: entry.driver.name,
                teamColor: Color.f1Team(entry.driver.team.name),
                size: 20,
                driverCode: entry.driver.code
            )

            Text(entry.driver.name)
                .font(.system(size: 12, weight: .medium))
                .foregroundColor(.white)
                .lineLimit(1)
        }
    }

    private func gridFinishCell(_ entry: RaceStatus.RaceResultEntry) -> some View {
        Text(Strings.DriverDetail.positionP(entry.driver.position))
            .font(.system(size: 11, weight: .medium, design: .monospaced))
            .foregroundColor(.white.opacity(0.5))
            .frame(width: 36, alignment: .trailing)
    }

    private func gridDeltaCell(_ entry: RaceStatus.RaceResultEntry) -> some View {
        let diff = entry.driver.position - entry.grid
        let text: String = diff == 0
            ? Strings.RaceDetail.gridDeltaSame
            : diff < 0
                ? String(format: Strings.RaceDetail.gridDeltaLoss, diff)
                : String(format: Strings.RaceDetail.gridDeltaGain, diff)
        let color: Color = diff < 0 ? .f1NeonGreen : diff > 0 ? .f1Accent : .white.opacity(0.3)
        return Text(text)
            .font(.system(size: 11, weight: .bold, design: .monospaced))
            .foregroundColor(color)
            .frame(width: 28, alignment: .trailing)
    }
}
