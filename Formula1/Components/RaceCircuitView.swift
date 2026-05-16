import SwiftUI

struct RaceCircuitView: View {
    let circuitName: String
    let country: String

    var body: some View {
        ZStack {
            CircuitTrackView(
                svgURL: F1Media.circuitSVGURL(circuitName: circuitName),
                neonGlow: true
            )
            .opacity(0.25)

            LinearGradient(
                colors: [.clear, .f1BackgroundDarker],
                startPoint: .top,
                endPoint: .bottom
            )
            .frame(height: 120)
            .frame(maxWidth: .infinity)
            .offset(y: 80)

            RadialGradient(
                colors: [.white.opacity(0.06), .clear],
                center: .topTrailing,
                startRadius: 20,
                endRadius: 300
            )
        }
        .frame(height: 200)
        .overlay(alignment: .bottomTrailing) {
            turnLabels
                .padding(12)
        }
    }

    @ViewBuilder
    private var turnLabels: some View {
        let labels = turnLabels(for: circuitName)
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
}
