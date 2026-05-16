import SwiftUI
import Kingfisher

struct PredictionCard: View {
    let predictions: [DriverPrediction]
    @State private var expandedFactor: String?
    @State private var animateProgress: Bool = false
    @State private var pulseTrigger: Bool = false
    @State private var showRegenerateHint: Bool = false
    @State private var showAISettings = false

    private var confidence: Double {
        guard predictions.count >= 2 else { return 0 }
        let top = predictions[0].score
        let second = predictions[1].score
        guard top > 0 else { return 0 }
        let gap = (top - second) / top
        return min(1, max(0, gap))
    }

    var body: some View {
        GlassCard {
            VStack(spacing: 16) {
                header
                if predictions.isEmpty {
                    emptyState
                } else {
                    confidenceBar
                    ForEach(Array(predictions.enumerated()), id: \.element.id) { index, pred in
                        predictionRow(pred, index: index)
                        if index < predictions.count - 1 {
                            Divider()
                                .overlay(Color.white.opacity(0.06))
                        }
                    }
                    regenerateHint
                }
            }
        }
        .padding(.horizontal)
        .onAppear {
            triggerAnimation()
        }
        .sheet(isPresented: $showAISettings) {
            AISettingsView()
        }
    }

    private func triggerAnimation() {
        animateProgress = false
        pulseTrigger = false
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
            withAnimation(.spring(response: 0.1)) {
                animateProgress = true
            }
            withAnimation(.easeInOut(duration: 1.2).repeatForever(autoreverses: true)) {
                pulseTrigger = true
            }
        }
    }

    // MARK: - Empty State

    private var emptyState: some View {
        VStack(spacing: 12) {
            Image(systemName: "brain.head.profile")
                .font(.system(size: 32))
                .foregroundColor(.f1TextSecondary.opacity(0.4))
            Text("No predictions available")
                .font(F1Theme.subheadline)
                .foregroundColor(.f1TextSecondary)
            Text("Data may still be loading")
                .font(.system(.caption2, design: .rounded))
                .foregroundColor(.f1TextSecondary.opacity(0.6))
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 24)
    }

    // MARK: - Header

    private var header: some View {
        HStack {
            ZStack {
                Image(systemName: "brain.head.profile")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.f1Accent)
                if pulseTrigger {
                    Image(systemName: "brain.head.profile")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(.f1Accent.opacity(0.3))
                        .scaleEffect(pulseTrigger ? 1.5 : 1)
                        .opacity(pulseTrigger ? 0 : 0.5)
                        .animation(.easeInOut(duration: 1.5).repeatForever(autoreverses: false), value: pulseTrigger)
                }
            }
            Text("AI Predictions")
                .font(F1Theme.headline)
                .foregroundColor(.white)
            Spacer()
            Button {
                showAISettings = true
            } label: {
                Image(systemName: "gearshape")
                    .font(.system(size: 12))
                    .foregroundColor(.f1TextSecondary.opacity(0.5))
            }
            .buttonStyle(.plain)
            Image(systemName: "sparkles")
                .font(.system(size: 10))
                .foregroundColor(.f1Accent)
            Text("Top 5")
                .font(.system(.caption2, design: .rounded))
                .foregroundColor(.f1TextSecondary)
                .padding(.horizontal, 8)
                .padding(.vertical, 3)
                .background(Capsule().fill(.ultraThinMaterial))
        }
    }

    // MARK: - Confidence Bar

    private var confidenceBar: some View {
        HStack(spacing: 6) {
            Image(systemName: confidence > 0.3 ? "bolt.fill" : "bolt")
                .font(.system(size: 9))
                .foregroundColor(confidenceColor)
            Text("AI Confidence")
                .font(.system(.caption2, design: .rounded))
                .foregroundColor(.f1TextSecondary)
            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 2)
                        .fill(Color.white.opacity(0.08))
                        .frame(height: 5)
                    RoundedRectangle(cornerRadius: 2)
                        .fill(confidenceColor)
                        .frame(width: (animateProgress ? geo.size.width * confidence : 0), height: 5)
                        .animation(.spring(response: 0.8, dampingFraction: 0.7).delay(0.15), value: animateProgress)
                }
            }
            .frame(height: 5)
            Text("\(Int(confidence * 100))%")
                .font(.system(.caption, design: .monospaced).weight(.bold))
                .foregroundColor(confidenceColor)
        }
        .padding(.horizontal, 2)
    }

    private var confidenceColor: Color {
        if confidence > 0.4 { return .f1NeonGreen }
        if confidence > 0.2 { return Color.yellow }
        return .f1TextSecondary
    }

    // MARK: - Prediction Row

    private func predictionRow(_ pred: DriverPrediction, index: Int) -> some View {
        VStack(spacing: 10) {
            HStack(spacing: 12) {
                driverPhoto(driverName: pred.driverName, position: pred.predictedPosition, index: index)

                VStack(alignment: .leading, spacing: 2) {
                    Text(pred.driverName)
                        .font(.system(.subheadline, design: .rounded).weight(.semibold))
                        .foregroundColor(.white)
                    HStack(spacing: 4) {
                        teamColorDot(teamName: pred.teamName)
                        Text(pred.teamName)
                            .font(.system(.caption2, design: .rounded))
                            .foregroundColor(.f1TextSecondary)
                    }
                }

                Spacer()

                VStack(alignment: .trailing, spacing: 2) {
                    Text("\(Int(pred.winProbability * 100))%")
                        .font(.system(.subheadline, design: .monospaced).weight(.bold))
                        .foregroundColor(winColor(pred.winProbability))
                    Text("win")
                        .font(.system(.caption2, design: .rounded))
                        .foregroundColor(.f1TextSecondary)
                }
            }

            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 2)
                        .fill(Color.white.opacity(0.06))
                        .frame(height: 4)
                    RoundedRectangle(cornerRadius: 2)
                        .fill(winColor(pred.winProbability))
                        .frame(width: (animateProgress ? geo.size.width * pred.winProbability : 0), height: 4)
                        .animation(.spring(response: 0.7, dampingFraction: 0.8).delay(0.3 + Double(index) * 0.08), value: animateProgress)
                }
            }
            .frame(height: 4)

            if expandedFactor == pred.id {
                factorBreakdown(pred)
                    .padding(.top, 4)
                if let reasoning = pred.reasoning {
                    HStack(spacing: 6) {
                        Image(systemName: "quote.opening")
                            .font(.system(size: 8))
                            .foregroundColor(.f1TextSecondary.opacity(0.4))
                        Text(reasoning)
                            .font(.system(.caption2, design: .rounded))
                            .foregroundColor(.f1TextSecondary.opacity(0.7))
                            .fixedSize(horizontal: false, vertical: true)
                    }
                    .padding(.top, 2)
                    .transition(.opacity.combined(with: .move(edge: .top)))
                }
            }
        }
        .contentShape(Rectangle())
        .onTapGesture {
            let impact = UIImpactFeedbackGenerator(style: .light)
            impact.impactOccurred()
            withAnimation(.spring(response: 0.3)) {
                expandedFactor = expandedFactor == pred.id ? nil : pred.id
            }
        }
    }

    // MARK: - Driver Photo

    private func driverPhoto(driverName: String, position: Int, index: Int) -> some View {
        ZStack {
            KFImage(F1Media.driverPhotoURL(driverName: driverName))
                .placeholder {
                    Circle()
                        .fill(positionColor(index).opacity(0.15))
                        .overlay(
                            Text("P\(position)")
                                .font(.system(size: 12, weight: .bold, design: .rounded))
                                .foregroundColor(positionColor(index))
                        )
                }
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 36, height: 36)
                .clipShape(Circle())
                .overlay(Circle().stroke(positionColor(index), lineWidth: 2))
                .overlay(
                    index == 0 && pulseTrigger
                    ? Circle().stroke(F1Theme.gold.opacity(0.4), lineWidth: 3)
                        .scaleEffect(pulseTrigger ? 1.15 : 1)
                        .opacity(pulseTrigger ? 0 : 0.6)
                        .animation(.easeInOut(duration: 1.2).repeatForever(autoreverses: false), value: pulseTrigger)
                    : nil
                )

            Circle()
                .fill(positionColor(index))
                .frame(width: 16, height: 16)
                .overlay(
                    Text("\(position)")
                        .font(.system(size: 9, weight: .bold, design: .rounded))
                        .foregroundColor(.black)
                )
                .offset(x: 14, y: -14)
        }
        .frame(width: 36, height: 36)
    }

    private func teamColorDot(teamName: String) -> some View {
        Circle()
            .fill(Color.f1Team(teamName))
            .frame(width: 8, height: 8)
    }

    // MARK: - Factor Breakdown

    private func factorBreakdown(_ pred: DriverPrediction) -> some View {
        VStack(spacing: 8) {
            ForEach(pred.factors) { factor in
                HStack(spacing: 8) {
                    Text(factor.label)
                        .font(.system(.caption2, design: .rounded))
                        .foregroundColor(.f1TextSecondary)
                        .frame(width: 60, alignment: .leading)

                    GeometryReader { geo in
                        ZStack(alignment: .leading) {
                            RoundedRectangle(cornerRadius: 3)
                                .fill(Color.white.opacity(0.06))
                                .frame(height: 14)
                            RoundedRectangle(cornerRadius: 3)
                                .fill(factorColor(factor))
                                .frame(width: (animateProgress ? geo.size.width * min(1, factor.weight * 3) : 0), height: 14)
                                .animation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.5), value: animateProgress)
                        }
                    }
                    .frame(height: 14)

                    Text(factor.value)
                        .font(.system(.caption, design: .monospaced).weight(.bold))
                        .foregroundColor(.white)
                        .frame(width: 48, alignment: .trailing)
                }
            }
        }
    }

    // MARK: - Regenerate Hint

    private var regenerateHint: some View {
        Button {
            triggerAnimation()
            let impact = UIImpactFeedbackGenerator(style: .medium)
            impact.impactOccurred()
        } label: {
            HStack(spacing: 6) {
                Image(systemName: "arrow.clockwise")
                    .font(.system(size: 10))
                Text("Re-animate")
                    .font(.system(.caption2, design: .rounded))
            }
            .foregroundColor(.f1TextSecondary.opacity(0.6))
            .frame(maxWidth: .infinity)
            .padding(.vertical, 6)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
    }

    // MARK: - Colors

    private func factorColor(_ factor: PredictionFactor) -> Color {
        switch factor.label {
        case "Career": return .f1Accent
        case "Season": return .f1NeonGreen
        case "Circuit": return .f1OrangeAccent
        case "Momentum": return .f1PurpleAccent
        case "Qualifying": return .f1OrangeLight
        case "Home": return .f1GoldLight
        default: return .f1Accent
        }
    }

    private func positionColor(_ index: Int) -> Color {
        switch index {
        case 0: return F1Theme.gold
        case 1: return F1Theme.silver
        case 2: return F1Theme.bronze
        default: return .f1TextSecondary
        }
    }

    private func winColor(_ probability: Double) -> Color {
        if probability > 0.5 { return .f1NeonGreen }
        if probability > 0.2 { return Color.yellow }
        return .f1TextSecondary
    }
}
