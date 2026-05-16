import SwiftUI

struct CountdownView: View {
    let targetDate: Date
    let title: String
    var isEmbedded: Bool = false

    @State private var timeRemaining: TimeInterval = 0
    private var isPast: Bool { timeRemaining <= 0 }

    var body: some View {
        Group {
            if isEmbedded {
                countdownContent
            } else {
                GlassCard { countdownContent }
            }
        }
        .onAppear {
            timeRemaining = targetDate.timeIntervalSinceNow
        }
        .task {
            while true {
                try? await Task.sleep(nanoseconds: 1_000_000_000)
                timeRemaining = targetDate.timeIntervalSinceNow
            }
        }
    }

    private var countdownContent: some View {
        VStack(spacing: 8) {
            if !title.isEmpty {
                Text(title)
                    .font(F1Theme.headline)
                    .foregroundColor(.white)
            }

            if isPast {
                Label(Strings.Countdown.raceWeekendLive, systemImage: "play.fill")
                    .font(F1Theme.subheadline)
                    .foregroundColor(.f1Accent)
                    .transition(.scale.combined(with: .opacity))
            } else {
                HStack(spacing: 16) {
                    countdownUnit(value: days, unit: Strings.Countdown.days)
                    countdownUnit(value: hours, unit: Strings.Countdown.hrs)
                    countdownUnit(value: minutes, unit: Strings.Countdown.min)
                    countdownUnit(value: seconds, unit: Strings.Countdown.sec)
                }
                .transition(.opacity)
            }
        }
    }

    private var days: Int { max(0, Int(timeRemaining) / 86400) }
    private var hours: Int { max(0, (Int(timeRemaining) % 86400) / 3600) }
    private var minutes: Int { max(0, (Int(timeRemaining) % 3600) / 60) }
    private var seconds: Int { max(0, Int(timeRemaining) % 60) }

    private func countdownUnit(value: Int, unit: String) -> some View {
        VStack(spacing: 2) {
            Text("\(value)")
                .font(.system(size: 28, weight: .bold, design: .rounded))
                .foregroundColor(.f1Accent)
                .monospacedDigit()
            Text(unit)
                .font(F1Theme.caption)
                .foregroundColor(.f1TextSecondary)
        }
        .frame(minWidth: 48)
    }
}
