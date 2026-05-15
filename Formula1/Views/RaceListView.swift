import SwiftUI

struct RaceListView: View {
    @StateObject private var viewModel: RaceListViewModel
    let onRaceTap: (Race) -> Void

    @MainActor
    init(viewModel: RaceListViewModel, onRaceTap: @escaping (Race) -> Void) {
        _viewModel = StateObject(wrappedValue: viewModel)
        self.onRaceTap = onRaceTap
    }

    var body: some View {
        Group {
            if viewModel.isLoading && viewModel.races.isEmpty {
                loadingView
            } else if let error = viewModel.error {
                errorView(error)
            } else {
                raceList
            }
        }
        .toolbarBackground(.hidden, for: .navigationBar)
        .task {
            await viewModel.loadRaces()
        }
    }

    private var loadingView: some View {
        VStack(spacing: 16) {
            ProgressView()
                .tint(.f1Accent)
                .scaleEffect(1.5)
            Text(Strings.RaceList.loading)
                .font(F1Theme.subheadline)
                .foregroundColor(.f1TextSecondary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(carbonBackground)
    }

    private func errorView(_ error: Error) -> some View {
        ContentUnavailableView(
            Strings.RaceList.errorTitle,
            systemImage: "exclamationmark.triangle.fill",
            description: Text(error.localizedDescription)
        )
        .foregroundColor(.f1Accent)
        .background(carbonBackground)
    }

    private var raceList: some View {
        ZStack {
            carbonBackground
            ScrollView {
                LazyVStack(spacing: 16) {
                    Color.clear
                        .frame(height: 4)
                        .padding(.horizontal, 16)

                    if let next = viewModel.races.first(where: { !$0.status.isCompleted }) {
                        heroCard(next)
                    }

                    Text(seasonYearText)
                        .font(.system(size: 20, weight: .bold, design: .default))
                        .foregroundColor(.white.opacity(0.8))
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal, 20)
                        .padding(.top, 8)

                    ForEach(Array(viewModel.races.enumerated()), id: \.element.id) { index, race in
                        raceCard(race, index: index)
                            .onTapGesture { onRaceTap(race) }
                    }

                    Color.clear
                        .frame(height: 20)
                }
                .padding(.vertical, 4)
            }
            .scrollContentBackground(.hidden)
        }
        .navigationTitle(Strings.RaceList.title)
        .navigationBarTitleDisplayMode(.large)
    }

    // MARK: - Hero Card

    private func heroCard(_ race: Race) -> some View {
        VStack(spacing: 0) {
            ZStack {
                CircuitTrackView(svgURL: F1Media.circuitSVGURL(circuitName: race.circuit.name))
                    .opacity(0.45)

                heroMotionStreaks

                Color(hex: "1A1A2E").opacity(0.85)

                VStack(spacing: 14) {
                    Text(Strings.RaceList.upNext)
                        .font(.system(size: 11, weight: .semibold, design: .default))
                        .foregroundColor(.f1Accent)
                        .tracking(4)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 4)
                        .background(Capsule().fill(.ultraThinMaterial))

                    Text(race.name.uppercased())
                        .font(.system(size: 22, weight: .bold, design: .default))
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)

                    HStack(spacing: 6) {
                        Text(countryFlag(race.circuit.country))
                            .font(.title3)
                        Text("\(race.circuit.name), \(race.circuit.country)")
                            .font(.system(size: 12, weight: .medium, design: .default))
                            .foregroundColor(.white.opacity(0.6))
                    }
                }
                .padding(20)
                .frame(maxHeight: .infinity)
            }
            .frame(height: 200)

            CountdownView(targetDate: race.date, title: "", isEmbedded: true)
                .padding(16)
                .frame(maxWidth: .infinity)
                .background(.ultraThinMaterial)
                .background(Color(hex: "1A1A2E").opacity(0.2))
        }
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(
                    LinearGradient(
                        colors: [.white.opacity(0.25), .white.opacity(0.05), .white.opacity(0.15)],
                        startPoint: .topLeading, endPoint: .bottomTrailing
                    ),
                    lineWidth: 1
                )
        )
        .shadow(color: Color(hex: "E10600").opacity(0.12), radius: 24, x: 0, y: 10)
        .padding(.horizontal, 16)
    }

    @State private var streakTime: Date = .now
    private let streakTimer = Timer.publish(every: 0.05, on: .main, in: .common).autoconnect()

    private var heroMotionStreaks: some View {
        Canvas { context, size in
            let time = streakTime.timeIntervalSinceReferenceDate
            for i in 0..<10 {
                let phase = Double(i) * 0.4
                let speed: Double = 50 + Double(i) * 8
                let totalWidth = size.width + 200
                let x = CGFloat((time * speed + phase * 60).truncatingRemainder(dividingBy: Double(totalWidth))) - 100
                let y = (size.height / 10) * CGFloat(i)
                let len: CGFloat = 60 + CGFloat(i) * 15
                let alpha = 0.04 + (sin(time * 0.3 + phase) * 0.025)

                var path = Path()
                path.move(to: CGPoint(x: x, y: y))
                path.addLine(to: CGPoint(x: x + len, y: y))
                context.stroke(path, with: .color(.white.opacity(alpha)), lineWidth: 1.5)
            }
        }
        .onReceive(streakTimer) { _ in streakTime = .now }
    }

    // MARK: - Race Card

    private func raceCard(_ race: Race, index: Int) -> some View {
        HStack(spacing: 14) {
            PositionBadge(position: race.round, color: .f1Accent, size: 46)

            VStack(alignment: .leading, spacing: 4) {
                Text(race.name.uppercased())
                    .font(.system(size: 15, weight: .bold, design: .default))
                    .foregroundColor(.white)

                HStack(spacing: 5) {
                    Text(countryFlag(race.circuit.country))
                        .font(.caption)
                    Text(race.circuit.location)
                        .font(.system(size: 12, weight: .regular, design: .default))
                        .foregroundColor(.white.opacity(0.45))
                }

                glassStatusBadge(race.status)
            }

            Spacer()

            Image(systemName: "chevron.right")
                .font(.caption)
                .foregroundColor(.white.opacity(0.25))
        }
        .padding(16)
        .background {
            CircuitTrackView(svgURL: F1Media.circuitSVGURL(circuitName: race.circuit.name))
                .opacity(0.18)
        }
        .background(.ultraThinMaterial)
        .background(Color(hex: "1A1A2E").opacity(0.25))
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(
                    LinearGradient(
                        colors: [.white.opacity(0.15), .white.opacity(0.03), .white.opacity(0.1)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    lineWidth: 1
                )
        )
        .shadow(color: .black.opacity(0.2), radius: 8, x: 0, y: 4)
        .padding(.horizontal, 16)
        .transition(.move(edge: .trailing).combined(with: .opacity))
        .animation(.spring(response: 0.4, dampingFraction: 0.8).delay(Double(index) * 0.03), value: viewModel.races.count)
    }

    // MARK: - Status Badge

    @ViewBuilder
    private func glassStatusBadge(_ status: RaceStatus) -> some View {
        switch status {
        case .completed:
            Label(Strings.RaceList.completed, systemImage: "checkmark.circle.fill")
                .font(.system(size: 11, weight: .semibold, design: .default))
                .foregroundColor(Color(hex: "39FF14"))
                .shadow(color: Color(hex: "39FF14").opacity(0.5), radius: 6, x: 0, y: 0)
        case .live:
            HStack(spacing: 4) {
                Circle()
                    .fill(Color.f1Accent)
                    .frame(width: 6, height: 6)
                    .opacity(0.9)
                Text(Strings.RaceList.live)
                    .font(.system(size: 11, weight: .bold, design: .default))
                    .foregroundColor(.f1Accent)
            }
        case .upcoming:
            Label(Strings.RaceList.upcoming, systemImage: "clock")
                .font(.system(size: 11, weight: .medium, design: .default))
                .foregroundColor(.white.opacity(0.4))
        }
    }

    // MARK: - Carbon Fiber Background

    @State private var carbonOffset: CGFloat = 0
    private let carbonTimer = Timer.publish(every: 0.05, on: .main, in: .common).autoconnect()

    private var carbonBackground: some View {
        Canvas { context, size in
            for i in stride(from: -40, to: Int(size.width + size.height) + 40, by: 6) {
                let x = CGFloat(i) - carbonOffset
                let y = CGFloat(i) * 0.5
                var path = Path()
                path.move(to: CGPoint(x: x, y: y - size.height))
                path.addLine(to: CGPoint(x: x + size.height, y: y + size.height))
                context.stroke(path, with: .color(.white.opacity(0.012)), lineWidth: 1)
            }
        }
        .background(Color(hex: "050508"))
        .ignoresSafeArea()
        .onReceive(carbonTimer) { _ in
            withAnimation(.linear(duration: 0.05)) { carbonOffset += 0.1 }
        }
    }

    // MARK: - Season Year

    private var seasonYearText: String {
        let year = Calendar.current.component(.year, from: viewModel.races.first?.date ?? Date())
        return "\(year) \(Strings.RaceList.seasonCalendar)"
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
