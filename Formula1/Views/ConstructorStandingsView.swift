import SwiftUI
import Kingfisher

struct ConstructorStandingsView: View {
    @StateObject private var viewModel: ConstructorStandingsViewModel
    let onConstructorTap: (ConstructorStanding) -> Void

    @MainActor
    init(viewModel: ConstructorStandingsViewModel, onConstructorTap: @escaping (ConstructorStanding) -> Void) {
        _viewModel = StateObject(wrappedValue: viewModel)
        self.onConstructorTap = onConstructorTap
    }

    private var standings: [ConstructorStanding] { viewModel.state.value ?? [] }

    var body: some View {
        Group {
            if viewModel.state.isLoading && standings.isEmpty {
                loadingView
            } else if let error = viewModel.state.error {
                errorView(error)
            } else {
                constructorList
            }
        }
        .navigationTitle(Strings.ConstructorList.title)
        .task {
            await viewModel.loadStandings()
        }
    }

    private var loadingView: some View {
        VStack(spacing: 16) {
            ProgressView()
                .tint(.f1Accent)
                .scaleEffect(1.5)
            Text(Strings.ConstructorList.loading)
                .font(F1Theme.subheadline)
                .foregroundColor(.f1TextSecondary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(F1Theme.background)
    }

    private func errorView(_ error: Error) -> some View {
        ContentUnavailableView(
            Strings.ConstructorList.errorTitle,
            systemImage: "exclamationmark.triangle.fill",
            description: Text(error.localizedDescription)
        )
        .foregroundColor(.f1Accent)
        .background(F1Theme.background)
    }

    private var constructorList: some View {
        ScrollView {
            LazyVStack(spacing: 8) {
                headerSection

                ForEach(Array(standings.enumerated()), id: \.element.id) { index, standing in
                    constructorRow(standing, index: index)
                        .onTapGesture { onConstructorTap(standing) }
                }
            }
            .padding(12)
        }
        .background(F1Theme.background)
    }

    private var headerSection: some View {
        VStack(spacing: 4) {
            Text(Strings.ConstructorStandings.season2026)
                .font(.system(size: 11, weight: .bold, design: .default))
                .foregroundColor(.f1Accent)
                .tracking(4)

            Text(Strings.ConstructorStandings.championship)
                .font(.system(size: 24, weight: .bold, design: .default))
                .foregroundColor(.white)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 16)
    }

    private func constructorRow(_ standing: ConstructorStanding, index: Int) -> some View {
        HStack(spacing: 12) {
            ConstructorColorBar(color: standing.constructor.color, height: 60)

            KFImage(F1Media.teamLogoURL(teamSlug: F1Media.teamSlug(for: standing.constructor.name)))
                .placeholder { _ in
                    PositionBadge(
                        position: standing.position,
                        color: standing.constructor.color,
                        size: 40
                    )
                }
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 40, height: 40)

            VStack(alignment: .leading, spacing: 2) {
                Text(standing.constructor.name)
                    .font(F1Theme.headline)
                    .foregroundColor(.white)
                    .lineLimit(1)

                Text(standing.wins == 1 ? Strings.ConstructorList.win(standing.wins) : Strings.ConstructorList.wins(standing.wins))
                    .font(F1Theme.caption)
                    .foregroundColor(.f1TextSecondary)
            }

            Spacer()

            VStack(alignment: .trailing, spacing: 2) {
                Text("\(standing.points)")
                    .font(F1Theme.statistic)
                    .foregroundColor(standing.constructor.color)

                Text(Strings.ConstructorStandings.points)
                    .font(F1Theme.caption)
                    .foregroundColor(.f1TextSecondary)
            }
        }
        .padding()
        .background(F1Theme.cardBackground)
        .clipShape(RoundedRectangle(cornerRadius: F1Theme.cornerRadius))
        .overlay(
            RoundedRectangle(cornerRadius: F1Theme.cornerRadius)
                .stroke(Color.white.opacity(0.05), lineWidth: 1)
        )
        .transition(.move(edge: .trailing).combined(with: .opacity))
        .animation(.spring(response: 0.4, dampingFraction: 0.8).delay(Double(index) * 0.02), value: standings.count)
    }
}

#Preview {
    PreviewWrapper {
        NavigationStack {
            ConstructorStandingsView(
                viewModel: .preview,
                onConstructorTap: { _ in }
            )
        }
    }
}
