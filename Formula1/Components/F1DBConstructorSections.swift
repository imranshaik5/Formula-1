import SwiftUI

// MARK: - All-Time Constructor Stats
struct F1DBConstructorAllTimeStatsSection: View {
    let constructor: F1DBConstructor

    var body: some View {
        GlassCard {
            VStack(spacing: 16) {
                Text(Strings.F1DB.allTimeStats)
                    .font(F1Theme.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity, alignment: .leading)

                LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 4), spacing: 16) {
                    statItem(label: Strings.F1DB.entries, value: "\(constructor.totalRaceEntries)")
                    statItem(label: Strings.F1DB.starts, value: "\(constructor.totalRaceStarts)")
                    statItem(label: Strings.F1DB.wins, value: "\(constructor.totalRaceWins)")
                    statItem(label: Strings.F1DB.oneTwoFinishes, value: "\(constructor.total1And2Finishes)")
                    statItem(label: Strings.F1DB.podiums, value: "\(constructor.totalPodiums)")
                    statItem(label: Strings.F1DB.polePositions, value: "\(constructor.totalPolePositions)")
                    statItem(label: Strings.F1DB.fastestLaps, value: "\(constructor.totalFastestLaps)")
                    statItem(label: Strings.F1DB.championships, value: "\(constructor.totalChampionshipWins)")
                    statItem(label: Strings.F1DB.points, value: formatPoints(constructor.totalPoints))
                    statItem(label: Strings.F1DB.bestChamp, value: constructor.bestChampionshipPosition.map { Strings.F1DB.StartingGrid.position($0) } ?? "—")
                    statItem(label: Strings.F1DB.bestResult, value: constructor.bestRaceResult.map { Strings.F1DB.StartingGrid.position($0) } ?? "—")
                    statItem(label: Strings.F1DB.sprintWins, value: "\(constructor.totalSprintRaceWins)")
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
                Text(Strings.F1DB.history)
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
                        Text("\u{2013} \(Strings.F1DB.present)")
                            .font(.system(.caption, design: .monospaced))
                    }
                }
                .foregroundColor(.f1TextSecondary)
            }

            Spacer()
        }
    }
}
