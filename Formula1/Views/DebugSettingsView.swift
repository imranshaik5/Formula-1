import SwiftUI

struct DebugSettingsView: View {
    @ObservedObject private var settings = DebugSettingsStore.shared

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                headerSection
                mockSection
                serverSection
                Spacer()
            }
            .padding()
        }
        .background(F1Theme.background)
        .navigationTitle(Strings.Debug.title)
    }

    private var headerSection: some View {
        GlassCard {
            VStack(spacing: 8) {
                Image(systemName: "wrench.adjustable.fill")
                    .font(.system(size: 32))
                    .foregroundColor(.f1Accent)
                Text(Strings.Debug.header)
                    .font(.title3.weight(.bold))
                    .foregroundColor(.white)
                Text(Strings.Debug.subtitle)
                    .font(.caption)
                    .foregroundColor(.f1TextSecondary)
                    .multilineTextAlignment(.center)
            }
            .padding()
        }
    }

    private var mockSection: some View {
        GlassCard {
            VStack(spacing: 16) {
                sectionLabel(Strings.Debug.mockSection)

                ToggleRow(
                    icon: "antenna.radiowaves.left.and.right",
                    title: Strings.Debug.mockMode,
                    subtitle: Strings.Debug.mockModeDetail,
                    isOn: $settings.mockModeEnabled
                )

                Divider().overlay(Color.white.opacity(0.06))

                ToggleRow(
                    icon: "bolt.fill",
                    title: Strings.Debug.forceLive,
                    subtitle: Strings.Debug.forceLiveDetail,
                    isOn: $settings.forceLiveRace
                )

                if settings.mockModeEnabled || settings.forceLiveRace {
                    Text(Strings.Debug.restartNote)
                        .font(.caption2)
                        .foregroundColor(.f1OrangeAccent)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
            .padding()
        }
    }

    private var serverSection: some View {
        GlassCard {
            VStack(spacing: 16) {
                sectionLabel(Strings.Debug.serverSection)

                VStack(alignment: .leading, spacing: 4) {
                    HStack {
                        Circle()
                            .fill(settings.mockModeEnabled ? Color.f1NeonGreen : Color.f1TextMuted)
                            .frame(width: 8, height: 8)
                        Text(settings.mockModeEnabled
                             ? Strings.Debug.mockServerStatus
                             : Strings.Debug.serverStatusIdle)
                            .font(.caption)
                            .foregroundColor(.f1TextSecondary)
                    }

                    Text(Strings.Debug.serverNote)
                        .font(.caption2)
                        .foregroundColor(.f1TextMuted)
                        .fixedSize(horizontal: false, vertical: true)
                }
            }
            .padding()
        }
    }

    private func sectionLabel(_ text: String) -> some View {
        HStack {
            Text(text.uppercased())
                .font(.caption.weight(.semibold))
                .foregroundColor(.f1Accent)
                .kerning(1.5)
            Spacer()
        }
    }
}

private struct ToggleRow: View {
    let icon: String
    let title: String
    let subtitle: String
    @Binding var isOn: Bool

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 18))
                .foregroundColor(isOn ? .f1Accent : .f1TextMuted)
                .frame(width: 24)

            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.body.weight(.medium))
                    .foregroundColor(.white)
                Text(subtitle)
                    .font(.caption2)
                    .foregroundColor(.f1TextSecondary)
            }

            Spacer()

            Toggle("", isOn: $isOn)
                .tint(.f1Accent)
                .labelsHidden()
        }
    }
}
