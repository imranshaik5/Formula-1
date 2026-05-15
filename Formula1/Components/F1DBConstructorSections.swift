import SwiftUI

// MARK: - All-Time Constructor Stats
struct F1DBConstructorAllTimeStatsSection: View {
    let constructor: F1DBConstructor

    var body: some View {
        GlassCard {
            VStack(spacing: 16) {
                Text("All-Time Stats")
                    .font(F1Theme.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity, alignment: .leading)

                LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 4), spacing: 16) {
                    statItem(label: "Entries", value: "\(constructor.totalRaceEntries)")
                    statItem(label: "Starts", value: "\(constructor.totalRaceStarts)")
                    statItem(label: "Wins", value: "\(constructor.totalRaceWins)")
                    statItem(label: "1-2 Finishes", value: "\(constructor.total1And2Finishes)")
                    statItem(label: "Podiums", value: "\(constructor.totalPodiums)")
                    statItem(label: "Pole Positions", value: "\(constructor.totalPolePositions)")
                    statItem(label: "Fastest Laps", value: "\(constructor.totalFastestLaps)")
                    statItem(label: "Championships", value: "\(constructor.totalChampionshipWins)")
                    statItem(label: "Points", value: formatPoints(constructor.totalPoints))
                    statItem(label: "Best Champ", value: constructor.bestChampionshipPosition.map { "P\($0)" } ?? "—")
                    statItem(label: "Best Result", value: constructor.bestRaceResult.map { "P\($0)" } ?? "—")
                    statItem(label: "Sprint Wins", value: "\(constructor.totalSprintRaceWins)")
                }
            }
        }
    }

    private func statItem(label: String, value: String) -> some View {
        VStack(spacing: 4) {
            Text(value)
                .font(.system(.subheadline, design: .monospaced).weight(.bold))
                .foregroundColor(.white)
            Text(label)
                .font(.system(.caption2, design: .rounded))
                .foregroundColor(.f1TextSecondary)
                .lineLimit(1)
        }
    }

    private func formatPoints(_ points: Double) -> String {
        if points >= 1000 { return "\(Int(points / 1000))k" }
        return points == floor(points) ? "\(Int(points))" : "\(points)"
    }
}

// MARK: - Constructor Chronology Timeline
struct F1DBConstructorChronologySection: View {
    let chronology: [F1DBConstructorChronology]
    let constructorNameLookup: (String) -> String

    var body: some View {
        GlassCard {
            VStack(spacing: 12) {
                Text("History")
                    .font(F1Theme.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity, alignment: .leading)

                VStack(spacing: 0) {
                    ForEach(Array(chronology.enumerated()), id: \.element.constructorId) { index, entry in
                        chronologyRow(entry, index: index)
                    }
                }
            }
        }
    }

    private func chronologyRow(_ entry: F1DBConstructorChronology, index: Int) -> some View {
        HStack(spacing: 12) {
            VStack(spacing: 0) {
                Circle()
                    .fill(Color.f1Accent)
                    .frame(width: 10, height: 10)
                if index < chronology.count - 1 {
                    Rectangle()
                        .fill(Color.f1Accent.opacity(0.3))
                        .frame(width: 2, height: 30)
                }
            }

            VStack(alignment: .leading, spacing: 2) {
                Text(constructorNameLookup(entry.constructorId))
                    .font(.system(.subheadline, design: .rounded).weight(.medium))
                    .foregroundColor(.white)

                HStack(spacing: 4) {
                    Text("\(entry.yearFrom)")
                        .font(.system(.caption, design: .monospaced))
                    if let yearTo = entry.yearTo {
                        Text("– \(yearTo)")
                            .font(.system(.caption, design: .monospaced))
                    } else {
                        Text("– Present")
                            .font(.system(.caption, design: .monospaced))
                    }
                }
                .foregroundColor(.f1TextSecondary)
            }

            Spacer()
        }
    }
}
