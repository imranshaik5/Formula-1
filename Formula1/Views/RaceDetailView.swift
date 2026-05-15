import SwiftUI

struct RaceDetailView: View {
    @StateObject private var viewModel: RaceDetailViewModel
    @StateObject private var f1dbService = F1DBService.shared
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
                circuitLayer

                VStack(spacing: 16) {
                    headerSection

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
        .background(Color(hex: "050505").ignoresSafeArea())
        .navigationTitle(viewModel.race.name)
        .navigationBarTitleDisplayMode(.inline)
        .task {
            await viewModel.loadRaceDetails()
            if !f1dbService.isLoaded { await f1dbService.load() }
        }
        .overlay {
            if viewModel.isLoading {
                Color(hex: "050505").opacity(0.6).ignoresSafeArea()
                ProgressView().tint(.f1Accent).scaleEffect(1.5)
            }
        }
    }

    private var content: some View {
        ScrollView {
            VStack(spacing: 0) {
                circuitLayer

                VStack(spacing: 16) {
                    headerSection

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
    }

    @ViewBuilder
    private func completedContent(_ result: RaceStatus.RaceResult) -> some View {
        winnerCard(result)
            .padding(.bottom, 8)

        sectionDivider("PODIUM")

        PodiumView(podium: result.podium, onDriverTap: onDriverTap)
            .padding(.top, 12)
            .padding(.bottom, 8)

        sectionDivider("CLASSIFICATION")

        resultsTable(result)

        if let details = result.details {
            if let fl = details.fastestLap {
                sectionDivider("FASTEST LAP")
                fastestLapSection(fl, totalLaps: details.totalLaps)
                    .padding(.horizontal)
            }

        sectionDivider("RACE DETAILS")
        raceDetailsSection(result)
            .padding(.horizontal)

        if let gp = f1dbRace.flatMap({ f1dbService.grandPrix(id: $0.grandPrixId) }) {
            sectionDivider("GRAND PRIX")
            F1DBGrandPrixBadgeSection(gp: gp)
        }
        if let race = f1dbRace {
            if let quali = race.qualifyingResults, !quali.isEmpty {
                sectionDivider("QUALIFYING")
                F1DBQualifyingResultsSection(
                    qualifying: quali,
                    driverNameLookup: f1dbDriverName(for:),
                    teamColorLookup: f1dbTeamColor(for:)
                )
            }
            if let grid = race.startingGridPositions, !grid.isEmpty {
                sectionDivider("STARTING GRID")
                F1DBStartingGridSection(
                    grid: grid,
                    driverNameLookup: f1dbDriverName(for:),
                    teamColorLookup: f1dbTeamColor(for:)
                )
            }
            if let fls = race.fastestLaps, !fls.isEmpty {
                sectionDivider("FASTEST LAPS")
                F1DBFastestLapsSection(
                    fastestLaps: fls,
                    driverNameLookup: f1dbDriverName(for:),
                    teamColorLookup: f1dbTeamColor(for:)
                )
            }
            if let stops = race.pitStops, !stops.isEmpty {
                sectionDivider("PIT STOPS")
                F1DBPitStopsSection(
                    pitStops: stops,
                    driverNameLookup: f1dbDriverName(for:)
                )
            }
            if let dotd = race.driverOfTheDayResults, !dotd.isEmpty {
                sectionDivider("DRIVER OF THE DAY")
                F1DBDriverOfTheDaySection(
                    dotd: dotd,
                    driverNameLookup: f1dbDriverName(for:)
                )
            }
        }

        sectionDivider("GRID vs FINISH")
        gridComparisonSection(result)
            .padding(.horizontal)

        sectionDivider("RACE MEDIA")
        raceMediaSection
            .padding(.bottom, 8)
    }

    // MARK: - Circuit Identity Layer

    private var circuitLayer: some View {
        ZStack {
            CircuitTrackView(
                svgURL: F1Media.circuitSVGURL(circuitName: viewModel.race.circuit.name),
                neonGlow: true
            )
            .opacity(0.25)

            LinearGradient(
                colors: [.clear, Color(hex: "050505")],
                startPoint: .top,
                endPoint: .bottom
            )
            .frame(height: 120)
            .frame(maxWidth: .infinity)
            .offset(y: 80)

            spotlightOverlay
        }
        .frame(height: 200)
        .overlay(alignment: .bottomTrailing) {
            circuitLabels
                .padding(12)
        }
    }

    private var spotlightOverlay: some View {
        RadialGradient(
            colors: [.white.opacity(0.06), .clear],
            center: .topTrailing,
            startRadius: 20,
            endRadius: 300
        )
    }

    @ViewBuilder
    private var circuitLabels: some View {
        let labels = turnLabels(for: viewModel.race.circuit.name)
        if !labels.isEmpty {
            VStack(alignment: .trailing, spacing: 2) {
                ForEach(labels.prefix(4), id: \.self) { label in
                    Text(label)
                        .font(.system(size: 8, weight: .regular, design: .monospaced))
                        .foregroundColor(.white.opacity(0.2))
                }
            }
        }
    }

    // MARK: - Header

    private var headerSection: some View {
        VStack(spacing: 8) {
            Text("ROUND \(viewModel.race.round)")
                .font(.system(size: 11, weight: .bold, design: .default))
                .foregroundColor(.f1Accent)
                .tracking(3)
                .padding(.horizontal, 12)
                .padding(.vertical, 4)
                .background(.ultraThinMaterial)
                .clipShape(Capsule())

            Text(viewModel.race.name.uppercased())
                .font(.system(size: 28, weight: .bold, design: .default))
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
                .padding(.horizontal)

            HStack(spacing: 6) {
                Text(countryFlag(viewModel.race.circuit.country))
                    .font(.title2)
                Text(viewModel.race.circuit.country)
                    .font(.system(size: 13, weight: .medium, design: .default))
                    .foregroundColor(.white.opacity(0.5))
            }
        }
    }

    // MARK: - Glassmorphism Winner Card

    private func winnerCard(_ result: RaceStatus.RaceResult) -> some View {
        VStack(spacing: 12) {
            HStack(spacing: 14) {
                DriverPhotoView(
                    driverName: result.winner.name,
                    teamColor: Color.f1Team(result.winner.team.name),
                    size: 52,
                    driverCode: result.winner.code
                )

                VStack(alignment: .leading, spacing: 2) {
                    Text("WINNER")
                        .font(.system(size: 9, weight: .bold, design: .default))
                        .foregroundColor(.yellow)
                        .tracking(3)

                    Text(result.winner.name)
                        .font(.system(size: 18, weight: .bold, design: .default))
                        .foregroundColor(.white)

                    Text(result.winner.team.name)
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(Color.f1Team(result.winner.team.name))
                }

                Spacer()
            }

            if let time = result.fullResults.first?.time {
                HStack(spacing: 6) {
                    Image(systemName: "clock.fill")
                        .font(.caption2)
                        .foregroundColor(.yellow.opacity(0.7))
                    Text(time)
                        .font(.system(size: 13, weight: .regular, design: .monospaced))
                        .foregroundColor(.white.opacity(0.7))
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
        .padding(16)
        .background(.ultraThinMaterial)
        .background(Color(hex: "1A1A2E").opacity(0.3))
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(
                    LinearGradient(
                        colors: [.yellow.opacity(0.6), .yellow.opacity(0.1), .yellow.opacity(0.3)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    lineWidth: 1
                )
        )
        .shadow(color: .yellow.opacity(0.08), radius: 20, x: 0, y: 8)
        .padding(.horizontal)
        .onTapGesture { onDriverTap?(result.winner) }
    }

    // MARK: - Fastest Lap

    private func fastestLapSection(_ fl: RaceStatus.FastestLap, totalLaps: Int) -> some View {
        GlassCard {
            HStack(spacing: 14) {
                DriverPhotoView(
                    driverName: fl.driver.name,
                    teamColor: Color.f1Team(fl.driver.team.name),
                    size: 40,
                    driverCode: fl.driver.code
                )

                VStack(alignment: .leading, spacing: 2) {
                    Text(fl.driver.name)
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(.white)

                    Text("Lap \(fl.lap) of \(totalLaps)")
                        .font(.system(size: 11, weight: .regular))
                        .foregroundColor(.f1TextSecondary)
                }

                Spacer()

                VStack(alignment: .trailing, spacing: 2) {
                    Text(fl.time)
                        .font(.system(size: 14, weight: .bold, design: .monospaced))
                        .foregroundColor(Color(hex: "B026FF"))

                    Text("\(fl.speed) kph")
                        .font(.system(size: 10, weight: .regular, design: .monospaced))
                        .foregroundColor(.f1TextSecondary)
                }
            }
        }
        .onTapGesture { onDriverTap?(fl.driver) }
    }

    // MARK: - Race Details

    private func raceDetailsSection(_ result: RaceStatus.RaceResult) -> some View {
        GlassCard {
            VStack(spacing: 12) {
                if let details = result.details {
                    detailRow(label: "Total Laps", value: "\(details.totalLaps)")
                }
                if let winnerTime = result.fullResults.first?.time {
                    detailRow(label: "Race Time", value: winnerTime)
                }
                detailRow(label: "Finishers", value: "\(result.fullResults.filter { $0.laps > 0 }.count)")
                detailRow(label: "Classified", value: "\(result.fullResults.count)")

                if let fl = result.details?.fastestLap {
                    Divider().background(.white.opacity(0.06))
                    detailRow(label: "Fastest Lap", value: fl.driver.name)
                    detailRow(label: "Fastest Lap Time", value: fl.time)
                    detailRow(label: "Avg Speed", value: "\(fl.speed) kph")
                }
            }
        }
    }

    // MARK: - Grid vs Finish

    private func gridComparisonSection(_ result: RaceStatus.RaceResult) -> some View {
        GlassCard {
            VStack(spacing: 0) {
                HStack(spacing: 10) {
                    Text("START")
                        .font(.system(size: 9, weight: .bold, design: .default))
                        .foregroundColor(.white.opacity(0.25))
                        .frame(width: 36, alignment: .leading)

                    Text("DRIVER")
                        .font(.system(size: 9, weight: .bold, design: .default))
                        .foregroundColor(.white.opacity(0.25))

                    Spacer()

                    Text("FINISH")
                        .font(.system(size: 9, weight: .bold, design: .default))
                        .foregroundColor(.white.opacity(0.25))
                        .frame(width: 36, alignment: .trailing)

                    Text("+/–")
                        .font(.system(size: 9, weight: .bold, design: .default))
                        .foregroundColor(.white.opacity(0.25))
                        .frame(width: 28, alignment: .trailing)
                }
                .padding(.bottom, 8)

                ForEach(Array(result.fullResults.prefix(10).enumerated()), id: \.element.driver.id) { _, entry in
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
            .onTapGesture { onDriverTap?(entry.driver) }

            Divider().background(.white.opacity(0.03))
        }
    }

    private func gridStartCell(_ entry: RaceStatus.RaceResultEntry) -> some View {
        Text("P\(entry.grid)")
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
        Text("P\(entry.driver.position)")
            .font(.system(size: 11, weight: .medium, design: .monospaced))
            .foregroundColor(.white.opacity(0.5))
            .frame(width: 36, alignment: .trailing)
    }

    private func gridDeltaCell(_ entry: RaceStatus.RaceResultEntry) -> some View {
        let diff = entry.driver.position - entry.grid
        let text: String = diff == 0 ? "–" : diff < 0 ? "\(diff)" : "+\(diff)"
        let color: Color = diff < 0 ? Color(hex: "39FF14") : diff > 0 ? .f1Accent : .white.opacity(0.3)
        return Text(text)
            .font(.system(size: 11, weight: .bold, design: .monospaced))
            .foregroundColor(color)
            .frame(width: 28, alignment: .trailing)
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

    // MARK: - Results Table

    private func resultsTable(_ result: RaceStatus.RaceResult) -> some View {
        VStack(spacing: 8) {
            HStack(spacing: 10) {
                Text("POS")
                    .font(.system(size: 9, weight: .bold, design: .default))
                    .foregroundColor(.white.opacity(0.25))
                    .frame(width: 24, alignment: .leading)

                Text("")
                    .frame(width: 24)

                Text("DRIVER")
                    .font(.system(size: 9, weight: .bold, design: .default))
                    .foregroundColor(.white.opacity(0.25))

                Spacer()

                Text("TIME")
                    .font(.system(size: 9, weight: .bold, design: .default))
                    .foregroundColor(.white.opacity(0.25))
                    .frame(width: 70, alignment: .trailing)

                Text("PTS")
                    .font(.system(size: 9, weight: .bold, design: .default))
                    .foregroundColor(.white.opacity(0.25))
                    .frame(width: 32, alignment: .trailing)
            }
            .padding(.horizontal, 12)

            GlassCard {
                VStack(spacing: 0) {
                    ForEach(Array(result.fullResults.enumerated()), id: \.element.driver.id) { index, entry in
                        resultRow(index: index, entry: entry, count: result.fullResults.count)
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

    // MARK: - Status / Upcoming

    @ViewBuilder
    private var statusSection: some View {
        switch viewModel.race.status {
        case .upcoming:
            CountdownView(targetDate: viewModel.race.date, title: "Race starts in")
                .padding(.horizontal)
        case .live:
            GlassCard {
                Label("Race is Live", systemImage: "play.fill")
                    .font(F1Theme.headline)
                    .foregroundColor(.f1Accent)
            }
            .padding(.horizontal)
        case .completed:
            EmptyView()
        }
    }

    private var circuitInfoSection: some View {
        GlassCard {
            VStack(alignment: .leading, spacing: 12) {
                Text("Circuit Information")
                    .font(F1Theme.headline)
                    .foregroundColor(.white)

                VStack(spacing: 8) {
                    detailRow(label: "Circuit", value: viewModel.race.circuit.name)
                    detailRow(label: "Location", value: viewModel.race.circuit.location)
                    detailRow(label: "Country", value: viewModel.race.circuit.country)
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

    // MARK: - Race Media

    private var raceMediaSection: some View {
        let categories: [(title: String, icon: String, query: String)] = [
            ("Highlights", "play.rectangle.fill", "highlights"),
            ("Top Rated", "star.fill", "race review"),
            ("Viral", "flame.fill", "viral moments"),
        ]
        return VStack(spacing: 12) {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 8) {
                    ForEach(categories.indices, id: \.self) { i in
                        Text(categories[i].title)
                            .font(.system(size: 11, weight: .semibold))
                            .foregroundColor(.white)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(Capsule().fill(Color.f1Accent))
                    }
                }
                .padding(.horizontal, 20)
            }

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(0..<5) { i in
                        mediaCard(index: i)
                    }
                }
                .padding(.horizontal, 20)
            }
        }
    }

    private func mediaCard(index: Int) -> some View {
        Button {
            let query = "F1 \(viewModel.race.name) 2026 highlights"
                .addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
            guard let url = URL(string: "https://www.youtube.com/results?search_query=\(query)") else { return }
            UIApplication.shared.open(url)
        } label: {
            VStack(alignment: .leading, spacing: 6) {
                ZStack {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(
                            LinearGradient(
                                colors: [.f1Accent.opacity(0.4 + Double(index) * 0.08), .blue.opacity(0.15)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 180, height: 100)

                    Image(systemName: "play.circle.fill")
                        .font(.system(size: 34))
                        .foregroundColor(.white.opacity(0.85))
                        .shadow(color: .black.opacity(0.4), radius: 6)
                }
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(.white.opacity(0.08), lineWidth: 1)
                )

                Text(mediaTitles[index])
                    .font(.system(size: 11, weight: .medium))
                    .foregroundColor(.white)
                    .lineLimit(2)
                    .frame(width: 180, alignment: .leading)

                HStack(spacing: 4) {
                    Image(systemName: "play.fill")
                        .font(.system(size: 8))
                    Text("\(Int.random(in: 5..<50) * 1000)")
                        .font(.system(size: 9, weight: .regular, design: .monospaced))
                }
                .foregroundColor(.f1TextSecondary)
            }
        }
    }

    private var mediaTitles: [String] {
        ["Race Highlights", "Best Overtakes", "First Lap Chaos", "Team Radio Moments", "Pit Stop Battle"]
    }

    // MARK: - Turn Labels

    private func turnLabels(for circuit: String) -> [String] {
        let lower = circuit.lowercased()
        if lower.contains("albert park") || lower.contains("melbourne") {
            return ["T1", "T3", "T9", "T11", "T13", "T15", "PIT"]
        }
        if lower.contains("silverstone") {
            return ["T1", "T4", "T6", "T9", "T15", "PIT"]
        }
        if lower.contains("monza") {
            return ["T1", "T4", "T5", "T8", "T11", "PIT"]
        }
        if lower.contains("monaco") {
            return ["T1", "T3", "T4", "T6", "T10", "T14", "T18", "PIT"]
        }
        if lower.contains("spa") || lower.contains("francorchamps") {
            return ["T1", "T5", "T8", "T10", "T14", "T18", "PIT"]
        }
        if lower.contains("suzuka") || lower.contains("japan") {
            return ["T1", "T2", "T7", "T9", "T11", "T14", "T16", "PIT"]
        }
        if lower.contains("marina bay") || lower.contains("singapore") {
            return ["T1", "T3", "T5", "T7", "T10", "T14", "T18", "T22", "PIT"]
        }
        if lower.contains("catalunya") || lower.contains("barcelona") {
            return ["T1", "T4", "T7", "T9", "T10", "T13", "PIT"]
        }
        if lower.contains("red bull") || lower.contains("spielberg") {
            return ["T1", "T3", "T4", "T6", "T8", "T10", "PIT"]
        }
        if lower.contains("interlagos") || lower.contains("são paulo") || lower.contains("brazil") {
            return ["T1", "T4", "T6", "T8", "T12", "T14", "PIT"]
        }
        if lower.contains("yas marina") || lower.contains("abu dhabi") {
            return ["T1", "T3", "T5", "T7", "T9", "T11", "T13", "T15", "PIT"]
        }
        return []
    }

    // MARK: - Flags

    private func countryFlag(_ country: String) -> String {
        let flags: [String: String] = [
            "Australia": "🇦🇺", "China": "🇨🇳", "USA": "🇺🇸", "Italy": "🇮🇹",
            "Monaco": "🇲🇨", "Canada": "🇨🇦", "Spain": "🇪🇸", "Austria": "🇦🇹",
            "Great Britain": "🇬🇧", "Hungary": "🇭🇺", "Belgium": "🇧🇪",
            "Netherlands": "🇳🇱", "Singapore": "🇸🇬", "Japan": "🇯🇵",
            "Qatar": "🇶🇦", "Mexico": "🇲🇽", "Brazil": "🇧🇷", "UAE": "🇦🇪",
            "Abu Dhabi": "🇦🇪", "Mexico City": "🇲🇽", "São Paulo": "🇧🇷"
        ]
        return flags[country, default: "🏁"]
    }
}
