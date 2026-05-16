import SwiftUI
import Kingfisher

struct ConstructorDetailView: View {
    @StateObject private var viewModel: ConstructorDetailViewModel
    @StateObject private var f1dbService = F1DBService.shared

    private var f1dbConstructor: F1DBConstructor? {
        let f1dbID = viewModel.standing.constructor.id.replacingOccurrences(of: "_", with: "-")
        return f1dbService.constructor(id: f1dbID)
    }

    init(standing: ConstructorStanding, constructorService: ConstructorServiceProtocol = ConstructorService()) {
        _viewModel = StateObject(wrappedValue: ConstructorDetailViewModel(
            standing: standing,
            constructorService: constructorService
        ))
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                heroSection
                statsSection
                if let constructor = f1dbConstructor {
                    F1DBConstructorAllTimeStatsSection(constructor: constructor)
                    if let chronology = constructor.chronology, !chronology.isEmpty {
                        F1DBConstructorChronologySection(
                            chronology: chronology,
                            constructorNameLookup: { id in
                                let c = f1dbService.constructor(id: id)
                                return c?.name ?? id
                            }
                        )
                    }
                }
                driverContributionsSection
                raceResultsSection
            }
            .padding(.vertical)
        }
        .background(F1Theme.background)
        .navigationTitle(viewModel.standing.constructor.name)
        .navigationBarTitleDisplayMode(.inline)
        .task {
            await viewModel.loadResults()
            if !f1dbService.isLoaded { await f1dbService.load() }
        }
    }

    private var heroSection: some View {
        VStack(spacing: 12) {
            KFImage(viewModel.teamLogoURL)
                .placeholder {
                    RoundedRectangle(cornerRadius: 20)
                        .fill(viewModel.teamColor.opacity(0.15))
                        .frame(width: 100, height: 100)
                        .overlay(
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(viewModel.teamColor, lineWidth: 2)
                        )
                        .overlay(
                            Text(abbreviation)
                                .font(.system(size: 36, weight: .bold, design: .rounded))
                                .foregroundColor(viewModel.teamColor)
                        )
                }
                .resizable()
                .scaledToFit()
                .frame(width: 100, height: 100)

            Text(viewModel.standing.constructor.name)
                .font(F1Theme.largeTitle)
                .foregroundColor(.white)

            HStack(spacing: 8) {
                Text("P\(viewModel.position) in standings")
                    .font(F1Theme.subheadline)
                    .foregroundColor(.f1TextSecondary)

                Text("\u{2022}")
                    .foregroundColor(.f1TextSecondary)

                Text(viewModel.standing.constructor.nationality)
                    .font(F1Theme.subheadline)
                    .foregroundColor(.f1TextSecondary)
            }
        }
        .padding(.horizontal)
    }

    private var statsSection: some View {
        GlassCard {
            VStack(spacing: 16) {
                Text("Season Statistics")
                    .font(F1Theme.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity, alignment: .leading)

                HStack(spacing: 0) {
                    statItem(label: "Position", value: "\(viewModel.position)", icon: "number")
                    Spacer()
                    statItem(label: "Points", value: "\(viewModel.totalPoints)", icon: "star.fill")
                    Spacer()
                    statItem(label: "Wins", value: "\(viewModel.wins)", icon: "trophy.fill")
                }

                VStack(alignment: .leading, spacing: 4) {
                    Text("Points Progress")
                        .font(F1Theme.caption)
                        .foregroundColor(.f1TextSecondary)

                    PointsBar(
                        points: viewModel.totalPoints,
                        maxPoints: max(viewModel.totalPoints, 500),
                        color: viewModel.teamColor
                    )
                }
            }
        }
        .padding(.horizontal)
    }

    private var driverContributionsSection: some View {
        GlassCard {
            VStack(spacing: 12) {
                Text("Driver Contributions")
                    .font(F1Theme.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity, alignment: .leading)

                ForEach(Array(viewModel.drivers.enumerated()), id: \.element.name) { index, driver in
                    HStack(spacing: 12) {
                        Text("\(index + 1)")
                            .font(.system(.subheadline, design: .monospaced))
                            .foregroundColor(.f1TextSecondary)
                            .frame(width: 24)

                        VStack(alignment: .leading, spacing: 2) {
                            Text(driver.name)
                                .font(.system(.subheadline, design: .rounded).weight(.semibold))
                                .foregroundColor(.white)

                            Text("\(driver.points) pts")
                                .font(.system(.caption, design: .rounded))
                                .foregroundColor(viewModel.teamColor)
                        }

                        Spacer()

                        Text("\(driver.points)")
                            .font(.system(.subheadline, design: .monospaced).weight(.bold))
                            .foregroundColor(.white)
                    }
                    .padding(.vertical, 4)

                    if index < viewModel.drivers.count - 1 {
                        Divider()
                            .background(.white.opacity(0.1))
                    }
                }
            }
        }
        .padding(.horizontal)
    }

    private var raceResultsSection: some View {
        GlassCard {
            VStack(spacing: 12) {
                Text("Race Results")
                    .font(F1Theme.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity, alignment: .leading)

                if viewModel.isLoading {
                    ProgressView()
                        .tint(.f1TextSecondary)
                        .padding(.vertical, 20)
                } else if viewModel.raceResults.isEmpty {
                    Text("No race data available")
                        .font(F1Theme.subheadline)
                        .foregroundColor(.f1TextSecondary)
                        .padding(.vertical, 20)
                } else {
                    ForEach(viewModel.raceResults) { race in
                        raceResultRow(race)
                    }
                }
            }
        }
        .padding(.horizontal)
    }

    @ViewBuilder
    private func raceResultRow(_ race: ConstructorRaceResult) -> some View {
        VStack(spacing: 8) {
            HStack {
                Text("R\(race.round)")
                    .font(.system(.caption, design: .monospaced))
                    .foregroundColor(.f1TextSecondary)
                    .frame(width: 32, alignment: .leading)

                Text(race.raceName)
                    .font(.system(.subheadline, design: .rounded).weight(.semibold))
                    .foregroundColor(.white)
                    .lineLimit(1)

                Spacer()

                Text(race.circuitName)
                    .font(.system(.caption, design: .rounded))
                    .foregroundColor(.f1TextSecondary)
                    .lineLimit(1)
            }

            ForEach(race.driverResults, id: \.driverId) { result in
                HStack(spacing: 8) {
                    Text("P\(result.position)")
                        .font(.system(.caption, design: .monospaced))
                        .foregroundColor(positionColor(result.position))
                        .frame(width: 28)

                    Text(result.driverName)
                        .font(.system(.caption, design: .rounded))
                        .foregroundColor(.white)

                    Spacer()

                    Text("+\(result.points)")
                        .font(.system(.caption, design: .monospaced).weight(.bold))
                        .foregroundColor(viewModel.teamColor)
                }
                .padding(.leading, 32)
            }
        }
        .padding(12)
        .background(viewModel.teamColor.opacity(0.08))
        .cornerRadius(10)

        if race != viewModel.raceResults.last {
            Divider()
                .background(.white.opacity(0.05))
        }
    }

    private func positionColor(_ position: Int) -> Color {
        switch position {
        case 1: return F1Theme.gold
        case 2: return F1Theme.silver
        case 3: return F1Theme.bronze
        default: return .f1TextSecondary
        }
    }

    private func statItem(label: String, value: String, icon: String) -> some View {
        VStack(spacing: 4) {
            Image(systemName: icon)
                .font(.title3)
                .foregroundColor(.f1TextSecondary)
            Text(value)
                .font(F1Theme.statistic)
                .foregroundColor(.white)
            Text(label)
                .font(F1Theme.caption)
                .foregroundColor(.f1TextSecondary)
        }
    }

    private var abbreviation: String {
        let words = viewModel.standing.constructor.name.split(separator: " ")
        if words.count == 1 {
            return String(words.first!.prefix(3)).uppercased()
        }
        return words.compactMap { $0.first }.map { String($0) }.joined().uppercased().prefix(3).description
    }
}
