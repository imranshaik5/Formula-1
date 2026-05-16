import SwiftUI

// MARK: - All-Time Career Stats
struct F1DBCareerStatsSection: View {
    let driver: F1DBDriver

    var body: some View {
        GlassCard {
            VStack(spacing: 16) {
                Text(Strings.F1DB.allTimeCareerStats)
                    .font(F1Theme.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity, alignment: .leading)

                LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 4), spacing: 16) {
                    statItem(label: Strings.F1DB.entries, value: "\(driver.totalRaceEntries)")
                    statItem(label: Strings.F1DB.starts, value: "\(driver.totalRaceStarts)")
                    statItem(label: Strings.F1DB.wins, value: "\(driver.totalRaceWins)")
                    statItem(label: Strings.F1DB.podiums, value: "\(driver.totalPodiums)")
                    statItem(label: Strings.F1DB.poles, value: "\(driver.totalPolePositions)")
                    statItem(label: Strings.F1DB.fastestLaps, value: "\(driver.totalFastestLaps)")
                    statItem(label: Strings.F1DB.dotd, value: "\(driver.totalDriverOfTheDay)")
                    statItem(label: Strings.F1DB.grandSlams, value: "\(driver.totalGrandSlams)")
                    statItem(label: Strings.F1DB.championships, value: "\(driver.totalChampionshipWins)")
                    statItem(label: Strings.F1DB.points, value: formatPoints(driver.totalChampionshipPoints))
                    statItem(label: Strings.F1DB.lapsLed, value: "\(driver.totalRaceLaps)")
                    statItem(label: Strings.F1DB.bestChamp, value: driver.bestChampionshipPosition.map { Strings.F1DB.StartingGrid.position($0) } ?? "—")
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
                Text(Strings.F1DB.family)
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
        case "CHILD": return Strings.F1DB.familyChild
        case "PARENT": return Strings.F1DB.familyParent
        case "SIBLING": return Strings.F1DB.familySibling
        case "SIBLINGS_CHILD": return Strings.F1DB.familyNieceNephew
        case "COUSIN": return Strings.F1DB.familyCousin
        case "MARRIED": return Strings.F1DB.familySpouse
        default: return type
        }
    }
}
