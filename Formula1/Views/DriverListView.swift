import SwiftUI
import Kingfisher

struct DriverListView: View {
    @StateObject private var viewModel: DriverListViewModel
    let onDriverTap: (Driver) -> Void

    @State private var carbonOffset: CGFloat = 0
    private let carbonTimer = Timer.publish(every: 0.05, on: .main, in: .common).autoconnect()

    @MainActor
    init(viewModel: DriverListViewModel, onDriverTap: @escaping (Driver) -> Void) {
        _viewModel = StateObject(wrappedValue: viewModel)
        self.onDriverTap = onDriverTap
    }

    var body: some View {
        Group {
            if viewModel.isLoading && viewModel.drivers.isEmpty {
                loadingView
            } else if let error = viewModel.error {
                errorView(error)
            } else {
                driverList
            }
        }
        .toolbarBackground(.hidden, for: .navigationBar)
        .task {
            await viewModel.loadDrivers()
        }
    }

    private var loadingView: some View {
        ZStack {
            carbonBackground
            VStack(spacing: 16) {
                ProgressView()
                    .tint(.f1Accent)
                    .scaleEffect(1.5)
                Text("Loading drivers...")
                    .font(F1Theme.subheadline)
                    .foregroundColor(.f1TextSecondary)
            }
        }
    }

    private func errorView(_ error: Error) -> some View {
        ZStack {
            carbonBackground
            ContentUnavailableView(
                "Error Loading Drivers",
                systemImage: "exclamationmark.triangle.fill",
                description: Text(error.localizedDescription)
            )
            .foregroundColor(.f1Accent)
        }
    }

    private var driverList: some View {
        ZStack {
            carbonBackground
            ScrollView {
                LazyVStack(spacing: 12) {
                    headerSection
                        .padding(.horizontal, 12)

                    ForEach(Array(viewModel.drivers.enumerated()), id: \.element.id) { index, driver in
                        driverCard(driver, index: index)
                            .onTapGesture { onDriverTap(driver) }
                            .transition(.opacity.combined(with: .move(edge: .trailing)))
                            .animation(.spring(response: 0.4, dampingFraction: 0.8).delay(Double(index) * 0.03), value: viewModel.drivers.count)
                    }

                    Color.clear.frame(height: 20)
                }
                .padding(.vertical, 12)
            }
            .scrollContentBackground(.hidden)
        }
    }

    private var headerSection: some View {
        VStack(spacing: 4) {
            Text("2026 SEASON")
                .font(.system(size: 11, weight: .bold, design: .default))
                .foregroundColor(.f1Accent)
                .tracking(4)

            Text("Driver Standings")
                .font(.system(size: 26, weight: .bold, design: .default))
                .foregroundColor(.white)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 20)
    }

    private func driverCard(_ driver: Driver, index: Int) -> some View {
        let teamColor = Color.f1Team(driver.team.name)
        let photoSize: CGFloat = 52
        return ZStack {
            RoundedRectangle(cornerRadius: F1Theme.cornerRadius)
                .fill(.ultraThinMaterial)
                .background(Color(hex: "1A1A2E").opacity(0.2))

            RoundedRectangle(cornerRadius: F1Theme.cornerRadius)
                .stroke(
                    LinearGradient(
                        colors: [teamColor.opacity(0.6), teamColor.opacity(0.1)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    lineWidth: 1
                )

            HStack(spacing: 14) {
                ZStack {
                    Circle()
                        .fill(teamColor.opacity(0.15))
                        .frame(width: 72, height: 72)
                        .blur(radius: 10)

                    DriverPhotoView(
                        driverName: driver.name,
                        teamColor: teamColor,
                        size: photoSize,
                        driverCode: driver.code
                    )
                    .overlay(
                        Circle()
                            .stroke(
                                LinearGradient(
                                    colors: [.black.opacity(0.35), .clear, .white.opacity(0.05)],
                                    startPoint: .top,
                                    endPoint: .bottom
                                ),
                                lineWidth: 2
                            )
                            .frame(width: photoSize, height: photoSize)
                    )
                }

                ZStack(alignment: .leading) {
                    Text("P\(driver.position)")
                        .font(.system(size: 68, weight: .black, design: .default))
                        .foregroundColor(teamColor.opacity(0.13))
                        .frame(maxWidth: .infinity, alignment: .leading)

                    VStack(alignment: .leading, spacing: 2) {
                        Text(driver.name)
                            .font(.system(size: 16, weight: .bold, design: .default))
                            .foregroundColor(.white)
                            .lineLimit(1)

                        HStack(spacing: 6) {
                            KFImage(F1Media.teamLogoURL(teamSlug: F1Media.teamSlug(for: driver.team.name)))
                                .placeholder { _ in
                                    Circle().fill(teamColor.opacity(0.3)).frame(width: 16, height: 16)
                                }
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 16, height: 16)

                            Text("|")
                                .font(.system(size: 12, weight: .regular, design: .default))
                                .foregroundColor(.white.opacity(0.5))

                            Text(driver.team.name)
                                .font(.system(size: 11, weight: .semibold, design: .default))
                                .foregroundColor(teamColor)
                                .lineLimit(1)
                        }
                    }
                    .offset(y: 8)
                }

                Spacer(minLength: 8)

                VStack(alignment: .trailing, spacing: 2) {
                    Text("\(driver.points)")
                        .font(.system(size: 20, weight: .bold, design: .monospaced))
                        .foregroundColor(.white)

                    Text("PTS")
                        .font(.system(size: 9, weight: .medium, design: .monospaced))
                        .foregroundColor(.white.opacity(0.3))
                        .tracking(2)
                }
            }
            .padding(.leading, 12)
            .padding(.trailing, 16)
            .padding(.vertical, 14)
        }
        .fixedSize(horizontal: false, vertical: true)
    }

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
}
