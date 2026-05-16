import SwiftUI

struct RaceListView: View {
    @StateObject private var viewModel: RaceListViewModel
    let onRaceTap: (Race) -> Void

    @MainActor
    init(viewModel: RaceListViewModel, onRaceTap: @escaping (Race) -> Void) {
        _viewModel = StateObject(wrappedValue: viewModel)
        self.onRaceTap = onRaceTap
    }

    private var races: [Race] { viewModel.state.value ?? [] }

    var body: some View {
        Group {
            if viewModel.state.isLoading && races.isEmpty {
                loadingView
            } else if let error = viewModel.state.error {
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
        .background(Color.f1BackgroundDeep)
    }

    private func errorView(_ error: Error) -> some View {
        ContentUnavailableView(
            Strings.RaceList.errorTitle,
            systemImage: "exclamationmark.triangle.fill",
            description: Text(error.localizedDescription)
        )
        .foregroundColor(.f1Accent)
        .background(Color.f1BackgroundDeep)
    }

    private var raceList: some View {
        ZStack {
            backgroundGradient
            ScrollView {
                LazyVStack(spacing: 16) {
                    Color.clear
                        .frame(height: 4)
                        .padding(.horizontal, 16)

                    if let next = races.first(where: { !$0.status.isCompleted }) {
                        heroCard(next)
                    }

                    Text(seasonYearText)
                        .font(.system(size: 20, weight: .bold, design: .default))
                        .foregroundColor(.white.opacity(0.8))
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal, 20)
                        .padding(.top, 8)

                    ForEach(Array(races.enumerated()), id: \.element.id) { index, race in
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

    private var backgroundGradient: some View {
        LinearGradient(
            colors: [
                .f1Accent.opacity(0.04),
                .clear,
                Color.f1BackgroundDeep,
            ],
            startPoint: .top,
            endPoint: .bottom
        )
        .ignoresSafeArea()
    }

    // MARK: - Hero Card

    private func heroCard(_ race: Race) -> some View {
        VStack(spacing: 0) {
            ZStack {
                CircuitTrackView(svgURL: F1Media.circuitSVGURL(circuitName: race.circuit.name))
                    .opacity(0.3)

                glassOverlay

                VStack(spacing: 14) {
                    Text(Strings.RaceList.upNext)
                        .font(.system(size: 11, weight: .semibold, design: .default))
                        .foregroundColor(.f1Accent)
                        .tracking(4)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 4)
                        .background(Capsule().fill(.ultraThinMaterial))
                        .overlay(
                            Capsule()
                                .stroke(Color.white.opacity(0.1), lineWidth: 1)
                        )

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
        .shadow(color: .f1Accent.opacity(0.12), radius: 24, x: 0, y: 10)
        .padding(.horizontal, 16)
    }

    private var glassOverlay: some View {
        Rectangle()
            .fill(.ultraThinMaterial)
            .opacity(0.6)
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
        .background(
            LinearGradient(
                colors: [.f1Accent.opacity(0.03), .clear],
                startPoint: .leading,
                endPoint: .trailing
            )
        )
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
        .animation(.spring(response: 0.4, dampingFraction: 0.8).delay(Double(index) * 0.03), value: races.count)
    }

    // MARK: - Status Badge

    @ViewBuilder
    private func glassStatusBadge(_ status: RaceStatus) -> some View {
        switch status {
        case .completed:
            Label(Strings.RaceList.completed, systemImage: "checkmark.circle.fill")
                .font(.system(size: 11, weight: .semibold, design: .default))
                .foregroundColor(.f1NeonGreen)
                .shadow(color: .f1NeonGreen.opacity(0.5), radius: 6, x: 0, y: 0)
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

    // MARK: - Season Year

    private var seasonYearText: String {
        let year = Calendar.current.component(.year, from: races.first?.date ?? Date())
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

#Preview {
    PreviewWrapper {
        NavigationStack {
            RaceListView(
                viewModel: .preview,
                onRaceTap: { _ in }
            )
        }
    }
}
