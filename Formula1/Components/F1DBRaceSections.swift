import SwiftUI

// MARK: - Grand Prix Badge
struct F1DBGrandPrixBadge: View {
    let gp: F1DBGrandPrix

    var body: some View {
        HStack(spacing: 8) {
            Text(gp.abbreviation)
                .font(.system(.caption, design: .monospaced).weight(.heavy))
                .foregroundColor(.f1Accent)
                .padding(.horizontal, 6)
                .padding(.vertical, 3)
                .background(Color.f1Accent.opacity(0.15))
                .cornerRadius(4)

            Text("Round \(gp.totalRacesHeld)")
                .font(.system(.caption2, design: .rounded))
                .foregroundColor(.f1TextSecondary)
        }
    }
}

struct F1DBGrandPrixBadgeSection: View {
    let gp: F1DBGrandPrix

    var body: some View {
        GlassCard {
            VStack(spacing: 12) {
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(gp.fullName)
                            .font(F1Theme.headline)
                            .foregroundColor(.white)

                        Text(gp.shortName)
                            .font(.system(.subheadline, design: .rounded))
                            .foregroundColor(.f1TextSecondary)
                    }

                    Spacer()

                    Text(gp.abbreviation)
                        .font(.system(.title, design: .monospaced).weight(.black))
                        .foregroundColor(.f1Accent.opacity(0.3))
                }

                HStack(spacing: 12) {
                    Label("\(gp.totalRacesHeld) races held", systemImage: "flag.checkered")
                        .font(.system(.caption, design: .rounded))
                        .foregroundColor(.f1TextSecondary)

                    if let countryId = gp.countryId, !countryId.isEmpty {
                        Label(countryId.replacingOccurrences(of: "-", with: " ").capitalized,
                              systemImage: "mappin")
                            .font(.system(.caption, design: .rounded))
                            .foregroundColor(.f1TextSecondary)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
        .padding(.horizontal)
    }
}

// MARK: - Qualifying Results
struct F1DBQualifyingResultsSection: View {
    let qualifying: [F1DBQualifyingResult]
    let driverNameLookup: (String) -> String
    let teamColorLookup: (String) -> Color

    var body: some View {
        GlassCard {
            VStack(spacing: 12) {
                sectionHeader("Qualifying")

                if qualifying.isEmpty {
                    emptyText
                } else {
                    // Header row
                    HStack(spacing: 4) {
                        Text("Pos").frame(width: 28, alignment: .leading)
                            .font(.system(.caption2, design: .monospaced)).foregroundColor(.f1TextSecondary)
                        Text("Driver").frame(maxWidth: .infinity, alignment: .leading)
                            .font(.system(.caption2, design: .monospaced)).foregroundColor(.f1TextSecondary)
                        Text("Q1").frame(width: 60, alignment: .trailing)
                            .font(.system(.caption2, design: .monospaced)).foregroundColor(.f1TextSecondary)
                        Text("Q2").frame(width: 60, alignment: .trailing)
                            .font(.system(.caption2, design: .monospaced)).foregroundColor(.f1TextSecondary)
                        Text("Q3").frame(width: 60, alignment: .trailing)
                            .font(.system(.caption2, design: .monospaced)).foregroundColor(.f1TextSecondary)
                    }
                    .padding(.horizontal, 8)

                    ForEach(qualifying.prefix(15), id: \.positionDisplayOrder) { result in
                        qualifyingRow(result)
                    }

                    if qualifying.count > 15 {
                        Text("+ \(qualifying.count - 15) more")
                            .font(.system(.caption, design: .rounded))
                            .foregroundColor(.f1TextSecondary)
                    }
                }
            }
        }
        .padding(.horizontal)
    }

    private func qualifyingRow(_ result: F1DBQualifyingResult) -> some View {
        HStack(spacing: 4) {
            Text(result.positionText)
                .font(.system(.caption, design: .monospaced))
                .foregroundColor(positionColor(result.positionNumber))
                .frame(width: 28, alignment: .leading)

            Text(driverNameLookup(result.driverId))
                .font(.system(.caption, design: .rounded))
                .foregroundColor(.white)
                .lineLimit(1)
                .frame(maxWidth: .infinity, alignment: .leading)

            Text(result.q1 ?? "—")
                .font(.system(.caption2, design: .monospaced))
                .foregroundColor(.f1TextSecondary)
                .frame(width: 60, alignment: .trailing)

            Text(result.q2 ?? "—")
                .font(.system(.caption2, design: .monospaced))
                .foregroundColor(.f1TextSecondary)
                .frame(width: 60, alignment: .trailing)

            Text(result.q3 ?? "—")
                .font(.system(.caption2, design: .monospaced))
                .foregroundColor(result.q3 != nil ? .white : .f1TextSecondary)
                .frame(width: 60, alignment: .trailing)
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 4)
        .background(result.positionNumber == 1 ? Color.f1Accent.opacity(0.08) : Color.clear)
        .cornerRadius(4)
    }
}

// MARK: - Starting Grid
struct F1DBStartingGridSection: View {
    let grid: [F1DBStartingGridPosition]
    let driverNameLookup: (String) -> String
    let teamColorLookup: (String) -> Color

    var body: some View {
        GlassCard {
            VStack(spacing: 12) {
                sectionHeader("Starting Grid")

                if grid.isEmpty {
                    emptyText
                } else {
                    ForEach(Array(grid.prefix(10).enumerated()), id: \.element.positionDisplayOrder) { _, entry in
                        gridRow(entry)
                    }
                    if grid.count > 10 {
                        Text("+ \(grid.count - 10) more")
                            .font(.system(.caption, design: .rounded))
                            .foregroundColor(.f1TextSecondary)
                    }
                }
            }
        }
        .padding(.horizontal)
    }

    private func gridRow(_ entry: F1DBStartingGridPosition) -> some View {
        HStack(spacing: 8) {
            Text("P\(entry.positionNumber ?? 0)")
                .font(.system(.caption, design: .monospaced).weight(.bold))
                .foregroundColor(positionColor(entry.positionNumber))
                .frame(width: 28)

            Text(driverNameLookup(entry.driverId))
                .font(.system(.subheadline, design: .rounded))
                .foregroundColor(.white)
                .lineLimit(1)

            Spacer()

            if let penalty = entry.gridPenalty {
                Text(penalty)
                    .font(.system(.caption2, design: .rounded))
                    .foregroundColor(.f1Accent)
            }

            if let time = entry.time {
                Text(time)
                    .font(.system(.caption, design: .monospaced))
                    .foregroundColor(.f1TextSecondary)
            }
        }
        .padding(.vertical, 3)
    }
}

// MARK: - Fastest Laps
struct F1DBFastestLapsSection: View {
    let fastestLaps: [F1DBFastestLap]
    let driverNameLookup: (String) -> String
    let teamColorLookup: (String) -> Color

    var body: some View {
        GlassCard {
            VStack(spacing: 12) {
                sectionHeader("Fastest Laps")

                if fastestLaps.isEmpty {
                    emptyText
                } else {
                    ForEach(Array(fastestLaps.prefix(5)), id: \.positionDisplayOrder) { lap in
                        HStack(spacing: 8) {
                            Image(systemName: "bolt.fill")
                                .font(.system(.caption))
                                .foregroundColor(.purple)
                                .frame(width: 20)

                            Text(driverNameLookup(lap.driverId))
                                .font(.system(.subheadline, design: .rounded))
                                .foregroundColor(.white)
                                .lineLimit(1)

                            Spacer()

                            if let lapNum = lap.lap {
                                Text("Lap \(lapNum)")
                                    .font(.system(.caption, design: .monospaced))
                                    .foregroundColor(.f1TextSecondary)
                            }

                            Text(lap.time ?? "—")
                                .font(.system(.caption, design: .monospaced).weight(.bold))
                                .foregroundColor(.purple)
                        }
                        .padding(.vertical, 3)
                    }
                }
            }
        }
        .padding(.horizontal)
    }
}

// MARK: - Pit Stops
struct F1DBPitStopsSection: View {
    let pitStops: [F1DBPitStop]
    let driverNameLookup: (String) -> String

    var body: some View {
        GlassCard {
            VStack(spacing: 12) {
                sectionHeader("Pit Stops")

                if pitStops.isEmpty {
                    emptyText
                } else {
                    ForEach(Array(pitStops.prefix(20)), id: \.stop) { stop in
                        HStack(spacing: 8) {
                            Text(driverNameLookup(stop.driverId))
                                .font(.system(.caption, design: .rounded))
                                .foregroundColor(.white)
                                .lineLimit(1)
                                .frame(maxWidth: .infinity, alignment: .leading)

                            Text("Lap \(stop.lap)")
                                .font(.system(.caption2, design: .monospaced))
                                .foregroundColor(.f1TextSecondary)

                            Text(stop.time)
                                .font(.system(.caption, design: .monospaced).weight(.bold))
                                .foregroundColor(.f1Accent)
                        }
                        .padding(.vertical, 2)
                    }
                }
            }
        }
        .padding(.horizontal)
    }
}

// MARK: - Driver of the Day
struct F1DBDriverOfTheDaySection: View {
    let dotd: [F1DBDriverOfTheDayResult]
    let driverNameLookup: (String) -> String

    var body: some View {
        GlassCard {
            VStack(spacing: 12) {
                sectionHeader("Driver of the Day")

                if dotd.isEmpty {
                    emptyText
                } else {
                    ForEach(Array(dotd.prefix(3)), id: \.positionDisplayOrder) { result in
                        HStack(spacing: 12) {
                            Image(systemName: "star.fill")
                                .font(.title3)
                                .foregroundColor(.yellow)

                            VStack(alignment: .leading, spacing: 2) {
                                Text(driverNameLookup(result.driverId))
                                    .font(.system(.subheadline, design: .rounded).weight(.semibold))
                                    .foregroundColor(.white)

                                if let pct = result.percentage {
                                    Text("\(String(format: "%.1f", pct))% of votes")
                                        .font(.system(.caption, design: .rounded))
                                        .foregroundColor(.f1TextSecondary)
                                }
                            }

                            Spacer()
                        }
                        .padding(.vertical, 4)
                    }
                }
            }
        }
        .padding(.horizontal)
    }
}

// MARK: - Helpers
private func sectionHeader(_ title: String) -> some View {
    Text(title)
        .font(F1Theme.headline)
        .foregroundColor(.white)
        .frame(maxWidth: .infinity, alignment: .leading)
}

private var emptyText: some View {
    Text("No data available")
        .font(F1Theme.subheadline)
        .foregroundColor(.f1TextSecondary)
        .padding(.vertical, 8)
}

private func positionColor(_ position: Int?) -> Color {
    guard let pos = position else { return .f1TextSecondary }
    switch pos {
    case 1: return Color(hex: "FFD700")
    case 2: return Color(hex: "C0C0C0")
    case 3: return Color(hex: "CD7F32")
    default: return .f1TextSecondary
    }
}
