import SwiftUI

struct LiveRaceView: View {
    @StateObject private var viewModel: LiveRaceViewModel

    init(viewModel: LiveRaceViewModel = LiveRaceViewModel()) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        VStack(spacing: 0) {
            if !viewModel.isConnected && viewModel.positions.isEmpty {
                connectingOverlay
            } else {
                sessionHeader
                    .padding(.horizontal)
                    .padding(.top, 8)
                livePositionsTable
                    .padding(.top, 8)
            }
        }
        .onAppear {
            Task { await viewModel.connect() }
        }
        .onDisappear {
            viewModel.disconnect()
        }
    }

    private var connectingOverlay: some View {
        GlassCard {
            VStack(spacing: 12) {
                ProgressView()
                    .tint(.f1Accent)
                Text(Strings.LiveTiming.connecting)
                    .font(F1Theme.subheadline)
                    .foregroundColor(.f1TextSecondary)
                if let error = viewModel.connectionError {
                    Text(error)
                        .font(.caption2)
                        .foregroundColor(.f1Accent)
                }
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 40)
        }
        .padding(.horizontal)
    }

    @ViewBuilder
    private var sessionHeader: some View {
        let sess = viewModel.session
        let trackStatus = TrackStatus(rawValue: sess.trackStatus)

        GlassCard {
            HStack(spacing: 16) {
                if let status = trackStatus {
                    trackStatusBadge(status.displayName, color: status.colorValue)
                }

                if sess.totalLaps > 0 {
                    HStack(spacing: 2) {
                        Text(Strings.LiveTiming.lapPrefix)
                            .font(F1Theme.caption)
                            .foregroundColor(.f1TextSecondary)
                        Text("\(sess.lapCount)/\(sess.totalLaps)")
                            .font(F1Theme.subheadline)
                            .foregroundColor(.white)
                            .monospacedDigit()
                    }
                }

                Spacer()

                if let air = sess.airTemp {
                    HStack(spacing: 4) {
                        Image(systemName: "thermometer.medium")
                            .font(.system(size: 10))
                            .foregroundColor(.f1TextSecondary)
                        Text("\(Int(air))°C")
                            .font(F1Theme.caption)
                            .foregroundColor(.f1TextSecondary)
                    }
                }
                if let track = sess.trackTemp {
                    HStack(spacing: 4) {
                        Image(systemName: "road.lanes")
                            .font(.system(size: 10))
                            .foregroundColor(.f1TextSecondary)
                        Text("\(Int(track))°C")
                            .font(F1Theme.caption)
                            .foregroundColor(.f1TextSecondary)
                    }
                }
            }
        }
    }

    private func trackStatusBadge(_ text: String, color: Color) -> some View {
        Text(text)
            .font(.system(size: 9, weight: .bold, design: .rounded))
            .foregroundColor(color)
            .padding(.horizontal, 8)
            .padding(.vertical, 3)
            .background(color.opacity(0.15))
            .clipShape(Capsule())
            .overlay(
                Capsule().stroke(color.opacity(0.3), lineWidth: 0.5)
            )
    }

    private var livePositionsTable: some View {
        GlassCard {
            VStack(spacing: 0) {
                tableHeader
                Divider()
                    .background(.white.opacity(0.06))
                    .padding(.horizontal, -F1Theme.cardPadding)
                ForEach(Array(viewModel.positions.enumerated()), id: \.element.id) { index, pos in
                    positionRow(pos, index: index)
                    if index < viewModel.positions.count - 1 {
                        Divider()
                            .background(.white.opacity(0.03))
                            .padding(.horizontal, -F1Theme.cardPadding)
                    }
                }
            }
        }
        .padding(.horizontal)
    }

    private var tableHeader: some View {
        HStack(spacing: 6) {
            Text(Strings.LiveTiming.pos)
                .font(.system(size: 9, weight: .bold, design: .default))
                .foregroundColor(.f1TextSecondary)
                .tracking(1.5)
                .frame(width: 28, alignment: .leading)

            Text(Strings.LiveTiming.driver)
                .font(.system(size: 9, weight: .bold, design: .default))
                .foregroundColor(.f1TextSecondary)
                .tracking(1.5)
                .frame(maxWidth: .infinity, alignment: .leading)

            Text(Strings.LiveTiming.gap)
                .font(.system(size: 9, weight: .bold, design: .default))
                .foregroundColor(.f1TextSecondary)
                .tracking(1.5)
                .frame(width: 52, alignment: .trailing)

            Text(Strings.LiveTiming.interval)
                .font(.system(size: 9, weight: .bold, design: .default))
                .foregroundColor(.f1TextSecondary)
                .tracking(1.5)
                .frame(width: 48, alignment: .trailing)

            Text(Strings.LiveTiming.lap)
                .font(.system(size: 9, weight: .bold, design: .default))
                .foregroundColor(.f1TextSecondary)
                .tracking(1.5)
                .frame(width: 52, alignment: .trailing)
        }
        .padding(.bottom, 8)
    }

    private func positionRow(_ pos: LiveDriverPosition, index: Int) -> some View {
        let driver = viewModel.driver(for: pos.driverNumber)
        let teamColor = Color.f1Team(driver?.team.name ?? "")
        let isFastestLap = pos.driverNumber == viewModel.fastestLap?.driverNumber
        let changedRecently = pos.position > 0 && pos.position <= 20

        return HStack(spacing: 6) {
            Text("P\(pos.position)")
                .font(.system(size: 13, weight: .bold, design: .rounded))
                .foregroundColor(teamColor)
                .monospacedDigit()
                .frame(width: 28, alignment: .leading)

            HStack(spacing: 6) {
                Rectangle()
                    .fill(teamColor)
                    .frame(width: 3, height: 24)
                    .clipShape(Capsule())

                VStack(alignment: .leading, spacing: 0) {
                    Text(viewModel.shortCode(for: pos.driverNumber))
                        .font(.system(size: 13, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                    Text(driver?.name ?? "#\(pos.driverNumber)")
                        .font(.system(size: 9, weight: .regular, design: .rounded))
                        .foregroundColor(.f1TextSecondary)
                        .lineLimit(1)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)

            Text(pos.gapToFront ?? "—")
                .font(.system(size: 11, weight: .medium, design: .monospaced))
                .foregroundColor(pos.position == 1 ? .f1NeonGreen : .f1TextSecondary)
                .frame(width: 52, alignment: .trailing)
                .monospacedDigit()

            Text(pos.intervalToAhead ?? "—")
                .font(.system(size: 11, weight: .medium, design: .monospaced))
                .foregroundColor(.f1TextSecondary)
                .frame(width: 48, alignment: .trailing)
                .monospacedDigit()

            Text(pos.lastLapTime ?? "—")
                .font(.system(size: 10, weight: .medium, design: .monospaced))
                .foregroundColor(isFastestLap ? .f1PurpleAccent : .f1TextSecondary)
                .frame(width: 52, alignment: .trailing)
                .monospacedDigit()
                .overlay(
                    isFastestLap ?
                    Image(systemName: "stopwatch.fill")
                        .font(.system(size: 8))
                        .foregroundColor(.f1PurpleAccent)
                        .offset(x: -58) : nil
                )
        }
        .padding(.vertical, 6)
        .padding(.leading, 4)
        .background(
            isFastestLap ?
            Color.f1PurpleAccent.opacity(0.06)
                .padding(.horizontal, -F1Theme.cardPadding) : nil
        )
    }
}
