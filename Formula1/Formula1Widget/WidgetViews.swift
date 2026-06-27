import SwiftUI
import WidgetKit

struct LargeWidgetView: View {
    let entry: WidgetEntry

    private let accentColor = Color(red: 225/255, green: 6/255, blue: 0/255)
    private let bgDark = Color(red: 10/255, green: 10/255, blue: 15/255)
    private let cardBg = Color(red: 26/255, green: 26/255, blue: 46/255)
    private let textSecondary = Color(red: 142/255, green: 142/255, blue: 152/255)

    var body: some View {
        VStack(spacing: 0) {
            header
            Spacer(minLength: 12)
            nextRaceSection
            Spacer(minLength: 16)
            HStack(spacing: 12) {
                driverStandingCard
                constructorStandingCard
            }
        }
        .padding(16)
        .containerBackground(bgDark, for: .widget)
    }

    private var header: some View {
        HStack(spacing: 8) {
            Image(systemName: "flag.checkered")
                .font(.system(size: 14, weight: .black))
                .foregroundColor(accentColor)
            Text("FORMULA 1")
                .font(.system(size: 14, weight: .black, design: .rounded))
                .kerning(2)
                .foregroundColor(.white)
            Spacer()
            Text(entry.date, style: .time)
                .font(.system(size: 11, weight: .medium, design: .rounded))
                .foregroundColor(textSecondary)
        }
    }

    private var nextRaceSection: some View {
        VStack(spacing: 4) {
            HStack {
                Text("NEXT RACE")
                    .font(.system(size: 10, weight: .semibold, design: .rounded))
                    .kerning(1.5)
                    .foregroundColor(accentColor)
                Spacer()
            }

            HStack {
                VStack(alignment: .leading, spacing: 2) {
                    Text(entry.data.nextRaceName)
                        .font(.system(size: 16, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                        .lineLimit(1)

                    Text(entry.data.nextRaceDate, style: .date)
                        .font(.system(size: 13, weight: .medium, design: .rounded))
                        .foregroundColor(textSecondary)
                }
                Spacer()

                if entry.data.nextRaceRound > 0 {
                    Text("R\(entry.data.nextRaceRound)")
                        .font(.system(size: 20, weight: .black, design: .rounded))
                        .foregroundColor(accentColor.opacity(0.3))
                }
            }
            .padding(12)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(cardBg)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.white.opacity(0.06), lineWidth: 1)
            )
        }
    }

    private var driverStandingCard: some View {
        standingCard(
            icon: "person.fill",
            title: "DRIVERS",
            name: entry.data.topDriverName,
            subtitle: entry.data.topDriverTeam,
            accent: accentColor
        )
    }

    private var constructorStandingCard: some View {
        standingCard(
            icon: "wrench.and.screwdriver.fill",
            title: "CONSTRUCTORS",
            name: entry.data.topConstructorName,
            subtitle: "\(entry.data.topConstructorPoints) PTS",
            accent: Color(red: 57/255, green: 255/255, blue: 20/255)
        )
    }

    private func standingCard(icon: String, title: String, name: String, subtitle: String, accent: Color) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack(spacing: 6) {
                ZStack {
                    RoundedRectangle(cornerRadius: 6)
                        .fill(accent)
                        .frame(width: 24, height: 24)
                    Image(systemName: icon)
                        .font(.system(size: 11, weight: .semibold))
                        .foregroundColor(.white)
                }
                Text(title)
                    .font(.system(size: 9, weight: .semibold, design: .rounded))
                    .kerning(1)
                    .foregroundColor(.white.opacity(0.8))
            }

            VStack(alignment: .leading, spacing: 2) {
                Text("P1")
                    .font(.system(size: 11, weight: .black, design: .rounded))
                    .foregroundColor(accent)
                Text(name)
                    .font(.system(size: 13, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                    .lineLimit(1)
                Text(subtitle)
                    .font(.system(size: 11, weight: .medium, design: .rounded))
                    .foregroundColor(textSecondary)
                    .lineLimit(1)
            }

            Spacer()
        }
        .padding(12)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(cardBg)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.white.opacity(0.06), lineWidth: 1)
        )
    }
}

#Preview(as: .systemLarge) {
    Formula1Widget()
} timeline: {
    WidgetEntry.preview
}
