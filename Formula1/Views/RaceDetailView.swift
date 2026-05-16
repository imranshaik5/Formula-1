import SwiftUI

struct RaceDetailView: View {
    @StateObject private var viewModel: RaceDetailViewModel
    @EnvironmentObject private var f1dbService: F1DBService
    var onDriverTap: ((Driver) -> Void)?

    private var raceYear: Int {
        let parts = viewModel.race.id.split(separator: "-")
        return Int(parts.first ?? "2026") ?? 2026
    }

    private var f1dbRace: F1DBRace? {
        f1dbService.race(year: raceYear, round: viewModel.race.round)
    }

    private func f1dbDriverName(for id: String) -> String {
        let d = f1dbService.driver(id: id)
        return d?.name ?? id.replacingOccurrences(of: "-", with: " ").capitalized
    }

    private func f1dbTeamColor(for id: String) -> Color {
        let c = f1dbService.constructor(id: id)
        return c.map { Color.f1Team($0.name) } ?? .f1TextSecondary
    }

    @MainActor
    init(viewModel: RaceDetailViewModel, onDriverTap: ((Driver) -> Void)? = nil) {
        _viewModel = StateObject(wrappedValue: viewModel)
        self.onDriverTap = onDriverTap
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                RaceCircuitView(
                    circuitName: viewModel.race.circuit.name,
                    country: viewModel.race.circuit.country
                )

                VStack(spacing: 16) {
                    RaceHeaderView(
                        raceName: viewModel.race.name,
                        round: viewModel.race.round,
                        country: viewModel.race.circuit.country
                    )

                    if case .completed(let result) = viewModel.race.status, let result {
                        completedContent(result)
                    } else {
                        statusSection
                        circuitInfoSection
                    }
                }
                .padding(.bottom, 24)
            }
        }
        .background(Color.f1BackgroundDarker.ignoresSafeArea())
        .navigationTitle(viewModel.race.name)
        .navigationBarTitleDisplayMode(.inline)
        .task {
            await viewModel.loadRaceDetails()
        }
        .overlay {
            if viewModel.loadState.isLoading {
                Color.f1BackgroundDarker.opacity(0.6).ignoresSafeArea()
                ProgressView().tint(.f1Accent).scaleEffect(1.5)
            }
        }
    }

    @ViewBuilder
    private func completedContent(_ result: RaceStatus.RaceResult) -> some View {
        RaceWinnerCard(
            winner: result.winner,
            winnerTime: result.fullResults.first?.time,
            onDriverTap: onDriverTap
        )
        .padding(.bottom, 8)

        sectionDivider(Strings.RaceDetail.sectionPodium)

        PodiumView(podium: result.podium, onDriverTap: onDriverTap)
            .padding(.top, 12)
            .padding(.bottom, 8)

        sectionDivider(Strings.RaceDetail.sectionClassification)

        RaceResultsTable(results: result.fullResults, onDriverTap: onDriverTap)

        if let details = result.details {
            if let fl = details.fastestLap {
                sectionDivider(Strings.RaceDetail.sectionFastestLap)
                RaceFastestLapCard(
                    driver: fl.driver,
                    lap: fl.lap,
                    totalLaps: details.totalLaps,
                    time: fl.time,
                    speed: fl.speed,
                    onDriverTap: onDriverTap
                )
                .padding(.horizontal)
            }

            sectionDivider(Strings.RaceDetail.sectionRaceDetails)
            RaceDetailsCard(
                totalLaps: details.totalLaps,
                winnerTime: result.fullResults.first?.time,
                finishers: result.fullResults.filter { $0.laps > 0 }.count,
                classified: result.fullResults.count,
                fastestLap: details.fastestLap.map { fl in
                    (driverName: fl.driver.name, time: fl.time, speed: fl.speed)
                }
            )
            .padding(.horizontal)
        }

        if let gp = f1dbRace.flatMap({ f1dbService.grandPrix(id: $0.grandPrixId) }) {
            sectionDivider(Strings.RaceDetail.sectionGrandPrix)
            F1DBGrandPrixBadgeSection(gp: gp)
        }
        if let race = f1dbRace {
            if let quali = race.qualifyingResults, !quali.isEmpty {
                sectionDivider(Strings.RaceDetail.sectionQualifying)
                F1DBQualifyingResultsSection(
                    qualifying: quali,
                    driverNameLookup: f1dbDriverName(for:),
                    teamColorLookup: f1dbTeamColor(for:)
                )
            }
            if let grid = race.startingGridPositions, !grid.isEmpty {
                sectionDivider(Strings.RaceDetail.sectionStartingGrid)
                F1DBStartingGridSection(
                    grid: grid,
                    driverNameLookup: f1dbDriverName(for:),
                    teamColorLookup: f1dbTeamColor(for:)
                )
            }
            if let fls = race.fastestLaps, !fls.isEmpty {
                sectionDivider(Strings.RaceDetail.sectionFastestLaps)
                F1DBFastestLapsSection(
                    fastestLaps: fls,
                    driverNameLookup: f1dbDriverName(for:),
                    teamColorLookup: f1dbTeamColor(for:)
                )
            }
            if let stops = race.pitStops, !stops.isEmpty {
                sectionDivider(Strings.RaceDetail.sectionPitStops)
                F1DBPitStopsSection(
                    pitStops: stops,
                    driverNameLookup: f1dbDriverName(for:)
                )
            }
            if let dotd = race.driverOfTheDayResults, !dotd.isEmpty {
                sectionDivider(Strings.RaceDetail.sectionDriverOfTheDay)
                F1DBDriverOfTheDaySection(
                    dotd: dotd,
                    driverNameLookup: f1dbDriverName(for:)
                )
            }
        }

        sectionDivider(Strings.RaceDetail.sectionGridVsFinish)
        RaceGridComparisonView(results: result.fullResults)
            .padding(.horizontal)

        sectionDivider(Strings.RaceDetail.sectionRaceMedia)
        RaceMediaSection(raceName: viewModel.race.name)
            .padding(.bottom, 8)
    }

    private func sectionDivider(_ title: String) -> some View {
        HStack(spacing: 12) {
            VStack { Divider().background(.white.opacity(0.06)) }
            Text(title)
                .font(.system(size: 9, weight: .bold, design: .default))
                .foregroundColor(.white.opacity(0.25))
                .tracking(3)
            VStack { Divider().background(.white.opacity(0.06)) }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 4)
    }

    @ViewBuilder
    private var statusSection: some View {
        switch viewModel.race.status {
        case .upcoming:
            CountdownView(targetDate: viewModel.race.date, title: Strings.RaceDetail.raceStartsIn)
                .padding(.horizontal)
            predictionsSection
        case .live:
            GlassCard {
                Label(Strings.RaceDetail.raceIsLive, systemImage: "play.fill")
                    .font(F1Theme.headline)
                    .foregroundColor(.f1Accent)
            }
            .padding(.horizontal)
        case .completed:
            EmptyView()
        }
    }

    @State private var aiPredictions: [DriverPrediction] = []
    @State private var aiLoaded = false
    @State private var aiLoading = false
    @State private var aiError = false

    @ViewBuilder
    private var predictionsSection: some View {
        Group {
            if aiLoading {
                loadingState
            } else if !aiError, !aiPredictions.isEmpty {
                PredictionCard(predictions: aiPredictions)
            } else {
                let fallback = F1DBPredictor(f1db: f1dbService).predictTop5(for: f1dbRace)
                PredictionCard(predictions: fallback)
            }
        }
        .task {
            await loadPredictions()
        }
    }

    @State private var brainPulse = false
    @State private var sparkleIndex = 0
    @State private var dotCount = 0
    @State private var loadingTimer: Timer?

    private var loadingState: some View {
        GlassCard {
            VStack(spacing: 16) {
                ZStack {
                    ForEach(0..<3, id: \.self) { i in
                        Image(systemName: "brain.head.profile")
                            .font(.system(size: 36))
                            .foregroundColor(.f1Accent.opacity(0.15 - Double(i) * 0.04))
                            .scaleEffect(brainPulse ? 1.0 + Double(i + 1) * 0.25 : 1.0)
                            .opacity(brainPulse ? 0 : 0.4)
                            .animation(
                                .easeOut(duration: 1.2).repeatForever(autoreverses: false).delay(Double(i) * 0.35),
                                value: brainPulse
                            )
                    }
                    Image(systemName: "brain.head.profile")
                        .font(.system(size: 36))
                        .foregroundColor(.f1Accent)
                        .scaleEffect(brainPulse ? 1.08 : 1.0)
                        .animation(.easeInOut(duration: 0.8).repeatForever(autoreverses: true), value: brainPulse)
                }

                Text("Analyzing with AI\(String(repeating: ".", count: dotCount % 4))")
                    .font(F1Theme.subheadline)
                    .foregroundColor(.f1TextSecondary)
                    .id(dotCount)

                HStack(spacing: 4) {
                    ForEach(0..<5, id: \.self) { i in
                        Capsule()
                            .fill(sparkleIndex == i ? Color.f1Accent : Color.white.opacity(0.08))
                            .frame(width: sparkleIndex == i ? 8 : 4, height: sparkleIndex == i ? 16 : 8)
                            .animation(.spring(response: 0.3, dampingFraction: 0.6), value: sparkleIndex)
                    }
                }

                Text("Running on local Llama 3.2")
                    .font(.system(.caption2, design: .rounded))
                    .foregroundColor(.f1TextSecondary.opacity(0.5))
            }
            .frame(maxWidth: .infinity)
        }
        .padding(.horizontal)
        .onAppear {
            brainPulse = true
            loadingTimer = Timer.scheduledTimer(withTimeInterval: 0.4, repeats: true) { _ in
                sparkleIndex = (sparkleIndex + 1) % 5
                dotCount += 1
            }
        }
        .onDisappear {
            loadingTimer?.invalidate()
            loadingTimer = nil
        }
    }

    private func loadPredictions() async {
        guard !aiLoaded else { return }
        let configStore = AIConfigStore.shared
        guard configStore.config.isConfigured else {
            aiPredictions = F1DBPredictor(f1db: f1dbService).predictTop5(for: f1dbRace)
            aiLoaded = true
            return
        }
        aiLoading = true
        do {
            let service = AIPredictionService(config: configStore.config, f1db: f1dbService)
            aiPredictions = try await service.predictTop5(for: f1dbRace)
            aiLoading = false
            aiLoaded = true
        } catch {
            aiLoading = false
            aiError = true
        }
    }

    private var circuitInfoSection: some View {
        GlassCard {
            VStack(alignment: .leading, spacing: 12) {
                Text(Strings.RaceDetail.circuitInfo)
                    .font(F1Theme.headline)
                    .foregroundColor(.white)

                VStack(spacing: 8) {
                    detailRow(label: Strings.RaceDetail.circuitLabel, value: viewModel.race.circuit.name)
                    detailRow(label: Strings.RaceDetail.locationLabel, value: viewModel.race.circuit.location)
                    detailRow(label: Strings.RaceDetail.countryLabel, value: viewModel.race.circuit.country)
                }
            }
        }
        .padding(.horizontal)
    }

    private func detailRow(label: String, value: String) -> some View {
        HStack {
            Text(label)
                .font(F1Theme.subheadline)
                .foregroundColor(.f1TextSecondary)
            Spacer()
            Text(value)
                .font(F1Theme.subheadline)
                .foregroundColor(.white)
        }
    }
}

#Preview {
    PreviewWrapper {
        NavigationStack {
            RaceDetailView(
                viewModel: .preview(for: PreviewData.completedRace),
                onDriverTap: { _ in }
            )
        }
    }
}

#Preview("Upcoming") {
    PreviewWrapper {
        NavigationStack {
            RaceDetailView(
                viewModel: .preview(for: PreviewData.race),
                onDriverTap: { _ in }
            )
        }
    }
}
