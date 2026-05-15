import SwiftUI

// MARK: - All-Time Career Stats
struct F1DBCareerStatsSection: View {
    let driver: F1DBDriver

    var body: some View {
        GlassCard {
            VStack(spacing: 16) {
                Text("All-Time Career Stats")
                    .font(F1Theme.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity, alignment: .leading)

                LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 4), spacing: 16) {
                    statItem(label: "Entries", value: "\(driver.totalRaceEntries)")
                    statItem(label: "Starts", value: "\(driver.totalRaceStarts)")
                    statItem(label: "Wins", value: "\(driver.totalRaceWins)")
                    statItem(label: "Podiums", value: "\(driver.totalPodiums)")
                    statItem(label: "Poles", value: "\(driver.totalPolePositions)")
                    statItem(label: "Fastest Laps", value: "\(driver.totalFastestLaps)")
                    statItem(label: "DOTD", value: "\(driver.totalDriverOfTheDay)")
                    statItem(label: "Grand Slams", value: "\(driver.totalGrandSlams)")
                    statItem(label: "Championships", value: "\(driver.totalChampionshipWins)")
                    statItem(label: "Points", value: formatPoints(driver.totalChampionshipPoints))
                    statItem(label: "Laps Led", value: "\(driver.totalRaceLaps)")
                    statItem(label: "Best Champ", value: driver.bestChampionshipPosition.map { "P\($0)" } ?? "—")
                }
            }
        }
        .padding(.horizontal)
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

// MARK: - Family Relationships
struct F1DBFamilyRelationshipsSection: View {
    let relationships: [F1DBDriverFamilyRelationship]
    let driverIDLookup: (String) -> String

    var body: some View {
        GlassCard {
            VStack(spacing: 12) {
                Text("Family")
                    .font(F1Theme.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity, alignment: .leading)

                ForEach(relationships, id: \.positionDisplayOrder) { rel in
                    HStack(spacing: 12) {
                        Image(systemName: iconFor(rel.type))
                            .font(.system(.body))
                            .foregroundColor(.f1TextSecondary)
                            .frame(width: 24)

                        Text(driverIDLookup(rel.driverId))
                            .font(.system(.subheadline, design: .rounded))
                            .foregroundColor(.white)

                        Spacer()

                        Text(labelFor(rel.type))
                            .font(.system(.caption, design: .rounded))
                            .foregroundColor(.f1TextSecondary)
                    }
                    .padding(.vertical, 2)

                    if rel.positionDisplayOrder < relationships.count {
                        Divider().background(.white.opacity(0.05))
                    }
                }
            }
        }
        .padding(.horizontal)
    }

    private func iconFor(_ type: String) -> String {
        switch type {
        case "CHILD": return "figure.2.and.child"
        case "PARENT": return "figure.2.and.child"
        case "SIBLING": return "figure.2"
        case "SIBLINGS_CHILD": return "figure.2.and.child"
        case "COUSIN": return "figure.2"
        case "MARRIED": return "heart"
        default: return "person.fill"
        }
    }

    private func labelFor(_ type: String) -> String {
        switch type {
        case "CHILD": return "Child"
        case "PARENT": return "Parent"
        case "SIBLING": return "Sibling"
        case "SIBLINGS_CHILD": return "Niece/Nephew"
        case "COUSIN": return "Cousin"
        case "MARRIED": return "Spouse"
        default: return type
        }
    }
}
