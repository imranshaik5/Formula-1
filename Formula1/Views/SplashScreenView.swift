import SwiftUI
import Kingfisher

struct SplashScreenView: View {
    let onComplete: () -> Void

    @State private var showLogo = false
    @State private var carSlideIn = false
    @State private var showTagline = false
    @State private var isDismissing = false

    private let autoDismissDelay: Double = 4.0

    var body: some View {
        ZStack {
            backgroundView
            bokehStreaks
                .opacity(showLogo ? 0.6 : 0)

            brandingSection
                .frame(maxHeight: .infinity, alignment: .top)
                .padding(.top, 60)
                .opacity(showLogo ? 1 : 0)
                .blur(radius: showLogo ? 0 : 4)
                .offset(y: showLogo ? 0 : -20)

            heroCarSection
                .offset(x: (carSlideIn ? 0 : UIScreen.main.bounds.width * 0.6) - 30)
                .opacity(carSlideIn ? 1 : 0)
                .scaleEffect(carSlideIn ? 1 : 0.85)

            taglineSection
                .frame(maxHeight: .infinity, alignment: .bottom)
                .padding(.bottom, 60)
                .opacity(showTagline ? 1 : 0)
                .offset(y: showTagline ? 0 : 15)

            Color.clear
                .contentShape(Rectangle())
                .onTapGesture { dismiss() }
        }
        .ignoresSafeArea()
        .opacity(isDismissing ? 0 : 1)
        .onAppear(perform: startAnimations)
    }

    // MARK: - Background

    private var backgroundView: some View {
        ZStack {
            Color.f1BackgroundDeep

            LinearGradient(
                colors: [
                    Color(hex: "0A0A14").opacity(0.8),
                    Color(hex: "14101A").opacity(0.4),
                    Color(hex: "05050A").opacity(0.9),
                ],
                startPoint: .top,
                endPoint: .bottom
            )

            RadialGradient(
                colors: [.f1OrangeAccent.opacity(0.08), .clear],
                center: .init(x: 0.5, y: 0.7),
                startRadius: 30,
                endRadius: 350
            )

            VStack {
                LinearGradient(
                    colors: [.black.opacity(0.6), .clear],
                    startPoint: .top, endPoint: .bottom
                )
                .frame(height: 160)
                Spacer()
                LinearGradient(
                    colors: [.clear, .black.opacity(0.6)],
                    startPoint: .top, endPoint: .bottom
                )
                .frame(height: 200)
            }
        }
    }

    // MARK: - Bokeh Motion Streaks

    private var bokehStreaks: some View {
        TimelineView(.animation) { timeline in
            Canvas { context, size in
                let time = timeline.date.timeIntervalSinceReferenceDate

                for i in 0..<20 {
                    let phase = Double(i) * 0.3
                    let speed: Double = 50 + Double(i) * 8
                    let totalWidth = size.width + 300
                    let rawX = (time * speed + phase * 100).truncatingRemainder(dividingBy: Double(totalWidth))
                    let x = CGFloat(rawX) - 150
                    let y = (size.height / 20) * CGFloat(i) + CGFloat(i * 3) + 20
                    let len: CGFloat = 60 + CGFloat(i) * 10
                    let alpha = 0.02 + (sin(time * 0.4 + phase) * 0.015 + 0.015)

                    let useWarm = i % 3 == 0
                    let color: Color = useWarm
                        ? .f1OrangeLight.opacity(alpha)
                        : Color.white.opacity(alpha * 0.8)

                    var path = Path()
                    path.move(to: CGPoint(x: x, y: y))
                    path.addLine(to: CGPoint(x: x + len, y: y))
                    context.stroke(path, with: .color(color), lineWidth: 1.5 + CGFloat(i % 3))
                }
            }
        }
    }

    // MARK: - Branding

    private var brandingSection: some View {
        VStack(spacing: 4) {
            KFImage(F1Media.logoImageURL)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 100, height: 100)
                .shadow(color: .white.opacity(0.1), radius: 8, x: 0, y: 2)

            Text(Strings.Splash.formula1)
                .font(.system(size: 14, weight: .semibold, design: .default))
                .foregroundColor(.white.opacity(0.85))
                .tracking(6.5)
        }
    }

    // MARK: - Hero Car

    private var heroCarSection: some View {
        ZStack(alignment: .trailing) {
            // Ground reflection glow
            LinearGradient(
                colors: [.f1OrangeAccent.opacity(0.12), .clear],
                startPoint: .bottom, endPoint: .top
            )
            .frame(height: 60)
            .offset(y: 40)
            .blur(radius: 20)

            // Car
            KFImage(F1Media.carImageURL)
                .placeholder { _ in
                    CarSilhouette()
                        .fill(.white.opacity(0.6))
                        .frame(width: 300, height: 100)
                }
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 340)
                .shadow(color: .f1OrangeAccent.opacity(0.15), radius: 30, x: 0, y: 10)

            // Sparks at rear
            SparksView()
                .offset(x: -150, y: -20)
        }
        .frame(height: 160)
    }

    // MARK: - Tagline

    private var taglineSection: some View {
        VStack(spacing: 6) {
            Text(Strings.Splash.startEngines)
                .font(.system(size: 15, weight: .semibold, design: .default))
                .foregroundColor(.white)
                .tracking(5)

            Text(Strings.Splash.getReady)
                .font(.system(size: 11, weight: .medium, design: .default))
                .foregroundColor(.white.opacity(0.5))
                .tracking(4)
        }
        .padding(.bottom, 80)
    }

    // MARK: - Animations

    private func startAnimations() {
        withAnimation(.easeOut(duration: 0.8).delay(0.2)) {
            showLogo = true
        }
        withAnimation(.interpolatingSpring(stiffness: 60, damping: 9).delay(0.5)) {
            carSlideIn = true
        }
        withAnimation(.easeOut(duration: 0.6).delay(1.0)) {
            showTagline = true
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + autoDismissDelay) {
            dismiss()
        }
    }

    private func dismiss() {
        guard !isDismissing else { return }
        withAnimation(.easeOut(duration: 0.35)) {
            isDismissing = true
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.35) {
            onComplete()
        }
    }
}

// MARK: - Sparks

struct SparksView: View {
    @State private var phase: Double = 0

    let timer = Timer.publish(every: 0.05, on: .main, in: .common).autoconnect()

    var body: some View {
        TimelineView(.animation) { timeline in
            Canvas { context, size in
                let time = timeline.date.timeIntervalSinceReferenceDate
                let w = size.width
                let h = size.height

                for i in 0..<8 {
                    let t = (time * 2.5 + Double(i) * 0.7).truncatingRemainder(dividingBy: 2.0)
                    let progress = t / 2.0
                    let x = w * 0.1 + CGFloat(progress) * w * 0.6
                    let y = h * 0.8 - CGFloat(progress) * h * 0.6
                    let alpha = 1.0 - progress
                    let radius: CGFloat = 1.0 + CGFloat(1.0 - progress) * 2.5

                    let color: Color = progress < 0.3
                        ? .f1GoldLight
                        : .f1OrangeLight

                    let rect = CGRect(
                        x: x - radius, y: y - radius,
                        width: radius * 2, height: radius * 2
                    )
                    context.fill(Path(ellipseIn: rect), with: .color(color.opacity(alpha)))
                }
            }
        }
        .frame(width: 100, height: 60)
    }
}

// MARK: - Car Silhouette Placeholder

struct CarSilhouette: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let w = rect.width
        let h = rect.height

        path.move(to: CGPoint(x: 0, y: h * 0.5))
        path.addCurve(
            to: CGPoint(x: w * 0.06, y: h * 0.32),
            control1: CGPoint(x: w * 0.02, y: h * 0.44),
            control2: CGPoint(x: w * 0.03, y: h * 0.32)
        )
        path.addLine(to: CGPoint(x: w * 0.12, y: h * 0.32))
        path.addLine(to: CGPoint(x: w * 0.12, y: h * 0.38))
        path.addCurve(
            to: CGPoint(x: w * 0.22, y: h * 0.32),
            control1: CGPoint(x: w * 0.16, y: h * 0.38),
            control2: CGPoint(x: w * 0.18, y: h * 0.32)
        )
        path.addLine(to: CGPoint(x: w * 0.3, y: h * 0.32))
        path.addCurve(
            to: CGPoint(x: w * 0.36, y: h * 0.22),
            control1: CGPoint(x: w * 0.32, y: h * 0.32),
            control2: CGPoint(x: w * 0.33, y: h * 0.22)
        )
        path.addCurve(
            to: CGPoint(x: w * 0.48, y: h * 0.22),
            control1: CGPoint(x: w * 0.4, y: h * 0.16),
            control2: CGPoint(x: w * 0.44, y: h * 0.16)
        )
        path.addLine(to: CGPoint(x: w * 0.5, y: h * 0.32))
        path.addCurve(
            to: CGPoint(x: w * 0.78, y: h * 0.28),
            control1: CGPoint(x: w * 0.6, y: h * 0.32),
            control2: CGPoint(x: w * 0.7, y: h * 0.28)
        )
        path.addLine(to: CGPoint(x: w * 0.84, y: h * 0.28))
        path.addLine(to: CGPoint(x: w * 0.9, y: h * 0.18))
        path.addLine(to: CGPoint(x: w * 0.97, y: h * 0.18))
        path.addLine(to: CGPoint(x: w * 0.97, y: h * 0.35))
        path.addLine(to: CGPoint(x: w, y: h * 0.38))
        path.addCurve(
            to: CGPoint(x: w, y: h * 0.45),
            control1: CGPoint(x: w, y: h * 0.4),
            control2: CGPoint(x: w, y: h * 0.43)
        )
        path.addLine(to: CGPoint(x: w, y: h * 0.5))
        path.addCurve(
            to: CGPoint(x: w * 0.97, y: h * 0.56),
            control1: CGPoint(x: w, y: h * 0.53),
            control2: CGPoint(x: w * 0.98, y: h * 0.55)
        )
        path.addLine(to: CGPoint(x: w * 0.97, y: h * 0.65))
        path.addLine(to: CGPoint(x: w * 0.9, y: h * 0.65))
        path.addLine(to: CGPoint(x: w * 0.84, y: h * 0.58))
        path.addCurve(
            to: CGPoint(x: w * 0.78, y: h * 0.62),
            control1: CGPoint(x: w * 0.82, y: h * 0.6),
            control2: CGPoint(x: w * 0.8, y: h * 0.62)
        )
        path.addLine(to: CGPoint(x: w * 0.65, y: h * 0.62))
        path.addCurve(
            to: CGPoint(x: w * 0.6, y: h * 0.68),
            control1: CGPoint(x: w * 0.63, y: h * 0.62),
            control2: CGPoint(x: w * 0.62, y: h * 0.68)
        )
        path.addLine(to: CGPoint(x: w * 0.42, y: h * 0.68))
        path.addCurve(
            to: CGPoint(x: w * 0.36, y: h * 0.62),
            control1: CGPoint(x: w * 0.4, y: h * 0.68),
            control2: CGPoint(x: w * 0.38, y: h * 0.62)
        )
        path.addLine(to: CGPoint(x: w * 0.28, y: h * 0.62))
        path.addCurve(
            to: CGPoint(x: w * 0.22, y: h * 0.58),
            control1: CGPoint(x: w * 0.26, y: h * 0.62),
            control2: CGPoint(x: w * 0.24, y: h * 0.6)
        )
        path.addCurve(
            to: CGPoint(x: w * 0.12, y: h * 0.55),
            control1: CGPoint(x: w * 0.18, y: h * 0.58),
            control2: CGPoint(x: w * 0.16, y: h * 0.55)
        )
        path.addLine(to: CGPoint(x: w * 0.12, y: h * 0.62))
        path.addLine(to: CGPoint(x: w * 0.06, y: h * 0.62))
        path.addLine(to: CGPoint(x: w * 0.06, y: h * 0.56))
        path.addCurve(
            to: CGPoint(x: 0, y: h * 0.5),
            control1: CGPoint(x: w * 0.03, y: h * 0.52),
            control2: CGPoint(x: w * 0.02, y: h * 0.5)
        )
        path.closeSubpath()
        return path
    }
}

#Preview {
    SplashScreenView(onComplete: {})
}
