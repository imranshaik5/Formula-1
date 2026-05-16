import SwiftUI

struct F1LogoShape: Shape {
    func path(in rect: CGRect) -> Path {
        Path { path in
            let sx = rect.width / 320
            let sy = rect.height / 80

            // Subpath 1 — "F" outer silhouette
            path.move(to: CGPoint(x: 45.2583 * sx, y: 80 * sy))
            path.addLine(to: CGPoint(x: 80.7417 * sx, y: 45.575 * sy))
            path.addLine(to: CGPoint(x: 80.7333 * sx, y: 45.575 * sy))
            path.addCurve(
                to: CGPoint(x: 127.058 * sx, y: 29.9583 * sy),
                control1: CGPoint(x: 94.7167 * sx, y: 32.0167 * sy),
                control2: CGPoint(x: 100.392 * sx, y: 29.9583 * sy)
            )
            path.addLine(to: CGPoint(x: 233.408 * sx, y: 29.9583 * sy))
            path.addLine(to: CGPoint(x: 264.008 * sx, y: 0 * sy))
            path.addLine(to: CGPoint(x: 123.025 * sx, y: 0 * sy))
            path.addCurve(
                to: CGPoint(x: 56.3083 * sx, y: 24.1167 * sy),
                control1: CGPoint(x: 87.3333 * sx, y: 0 * sy),
                control2: CGPoint(x: 77.2417 * sx, y: 3.4 * sy)
            )
            path.addLine(to: CGPoint(x: 0 * sx, y: 80 * sy))
            path.addLine(to: CGPoint(x: 45.2583 * sx, y: 80 * sy))
            path.closeSubpath()

            // Subpath 2 — "F" inner counter (even-odd creates the hole)
            path.move(to: CGPoint(x: 127.7 * sx, y: 34.7417 * sy))
            path.addLine(to: CGPoint(x: 228.842 * sx, y: 34.7417 * sy))
            path.addLine(to: CGPoint(x: 200.792 * sx, y: 62.7917 * sy))
            path.addLine(to: CGPoint(x: 128.225 * sx, y: 62.7917 * sy))
            path.addCurve(
                to: CGPoint(x: 105.383 * sx, y: 70.0167 * sy),
                control1: CGPoint(x: 114.925 * sx, y: 62.7917 * sy),
                control2: CGPoint(x: 111.983 * sx, y: 63.4167 * sy)
            )
            path.addLine(to: CGPoint(x: 95.4 * sx, y: 80 * sy))
            path.addLine(to: CGPoint(x: 53.4333 * sx, y: 80 * sy))
            path.addLine(to: CGPoint(x: 84.4583 * sx, y: 48.975 * sy))
            path.addCurve(
                to: CGPoint(x: 127.7 * sx, y: 34.7417 * sy),
                control1: CGPoint(x: 96.6417 * sx, y: 36.8 * sy),
                control2: CGPoint(x: 100.842 * sx, y: 34.7417 * sy)
            )
            path.closeSubpath()

            // Subpath 3 — "1" numeral
            path.move(to: CGPoint(x: 320 * sx, y: 0 * sy))
            path.addLine(to: CGPoint(x: 239.783 * sx, y: 80 * sy))
            path.addLine(to: CGPoint(x: 190.175 * sx, y: 80 * sy))
            path.addLine(to: CGPoint(x: 270.175 * sx, y: 0 * sy))
            path.addLine(to: CGPoint(x: 320 * sx, y: 0 * sy))
            path.closeSubpath()

            // Subpath 4 — Trademark "T" outer
            path.move(to: CGPoint(x: 267.183 * sx, y: 77.4667 * sy))
            path.addCurve(
                to: CGPoint(x: 273.475 * sx, y: 80 * sy),
                control1: CGPoint(x: 268.85 * sx, y: 79.1583 * sy),
                control2: CGPoint(x: 270.95 * sx, y: 80 * sy)
            )
            path.addCurve(
                to: CGPoint(x: 279.717 * sx, y: 77.4833 * sy),
                control1: CGPoint(x: 276 * sx, y: 80 * sy),
                control2: CGPoint(x: 278.075 * sx, y: 79.1583 * sy)
            )
            path.addCurve(
                to: CGPoint(x: 282.175 * sx, y: 71.2667 * sy),
                control1: CGPoint(x: 281.358 * sx, y: 75.8083 * sy),
                control2: CGPoint(x: 282.175 * sx, y: 73.7333 * sy)
            )
            path.addCurve(
                to: CGPoint(x: 279.7 * sx, y: 65.0333 * sy),
                control1: CGPoint(x: 282.175 * sx, y: 68.8 * sy),
                control2: CGPoint(x: 281.35 * sx, y: 66.725 * sy)
            )
            path.addCurve(
                to: CGPoint(x: 273.442 * sx, y: 62.5 * sy),
                control1: CGPoint(x: 278.05 * sx, y: 63.3417 * sy),
                control2: CGPoint(x: 275.967 * sx, y: 62.5 * sy)
            )
            path.addCurve(
                to: CGPoint(x: 267.167 * sx, y: 65.0167 * sy),
                control1: CGPoint(x: 270.917 * sx, y: 62.5 * sy),
                control2: CGPoint(x: 268.825 * sx, y: 63.3417 * sy)
            )
            path.addCurve(
                to: CGPoint(x: 264.675 * sx, y: 71.2333 * sy),
                control1: CGPoint(x: 265.508 * sx, y: 66.6917 * sy),
                control2: CGPoint(x: 264.675 * sx, y: 68.7667 * sy)
            )
            path.addCurve(
                to: CGPoint(x: 267.183 * sx, y: 77.4667 * sy),
                control1: CGPoint(x: 264.675 * sx, y: 73.7 * sy),
                control2: CGPoint(x: 265.508 * sx, y: 75.775 * sy)
            )
            path.closeSubpath()

            // Subpath 5 — Trademark inner cutout
            path.move(to: CGPoint(x: 268.225 * sx, y: 66.025 * sy))
            path.addCurve(
                to: CGPoint(x: 273.425 * sx, y: 63.875 * sy),
                control1: CGPoint(x: 269.625 * sx, y: 64.5917 * sy),
                control2: CGPoint(x: 271.358 * sx, y: 63.875 * sy)
            )
            path.addCurve(
                to: CGPoint(x: 278.625 * sx, y: 66.025 * sy),
                control1: CGPoint(x: 275.5 * sx, y: 63.875 * sy),
                control2: CGPoint(x: 277.233 * sx, y: 64.5917 * sy)
            )
            path.addCurve(
                to: CGPoint(x: 280.717 * sx, y: 71.25 * sy),
                control1: CGPoint(x: 280.017 * sx, y: 67.4583 * sy),
                control2: CGPoint(x: 280.717 * sx, y: 69.2 * sy)
            )
            path.addCurve(
                to: CGPoint(x: 278.625 * sx, y: 76.4583 * sy),
                control1: CGPoint(x: 280.717 * sx, y: 73.3 * sy),
                control2: CGPoint(x: 280.017 * sx, y: 75.0333 * sy)
            )
            path.addCurve(
                to: CGPoint(x: 273.425 * sx, y: 78.5917 * sy),
                control1: CGPoint(x: 277.225 * sx, y: 77.8833 * sy),
                control2: CGPoint(x: 275.5 * sx, y: 78.5917 * sy)
            )
            path.addCurve(
                to: CGPoint(x: 268.225 * sx, y: 76.4417 * sy),
                control1: CGPoint(x: 271.35 * sx, y: 78.5917 * sy),
                control2: CGPoint(x: 269.617 * sx, y: 77.875 * sy)
            )
            path.addCurve(
                to: CGPoint(x: 266.133 * sx, y: 71.2333 * sy),
                control1: CGPoint(x: 266.833 * sx, y: 75.0083 * sy),
                control2: CGPoint(x: 266.133 * sx, y: 73.275 * sy)
            )
            path.addCurve(
                to: CGPoint(x: 268.225 * sx, y: 66.025 * sy),
                control1: CGPoint(x: 266.133 * sx, y: 69.1917 * sy),
                control2: CGPoint(x: 266.833 * sx, y: 67.4583 * sy)
            )
            path.closeSubpath()

            // Subpath 6 — Trademark "T" horizontal bar
            path.move(to: CGPoint(x: 271.717 * sx, y: 76.125 * sy))
            path.addLine(to: CGPoint(x: 271.717 * sx, y: 72.6917 * sy))
            path.addLine(to: CGPoint(x: 271.725 * sx, y: 72.7 * sy))
            path.addLine(to: CGPoint(x: 273.683 * sx, y: 72.7 * sy))
            path.addLine(to: CGPoint(x: 275.342 * sx, y: 76.1333 * sy))
            path.addLine(to: CGPoint(x: 277.367 * sx, y: 76.1333 * sy))
            path.addLine(to: CGPoint(x: 275.542 * sx, y: 72.45 * sy))
            path.addCurve(
                to: CGPoint(x: 276.85 * sx, y: 71.3417 * sy),
                control1: CGPoint(x: 276.158 * sx, y: 72.1667 * sy),
                control2: CGPoint(x: 276.592 * sx, y: 71.8 * sy)
            )
            path.addCurve(
                to: CGPoint(x: 277.233 * sx, y: 69.2417 * sy),
                control1: CGPoint(x: 277.108 * sx, y: 70.8833 * sy),
                control2: CGPoint(x: 277.233 * sx, y: 70.1833 * sy)
            )
            path.addCurve(
                to: CGPoint(x: 276.283 * sx, y: 67.125 * sy),
                control1: CGPoint(x: 277.233 * sx, y: 68.3 * sy),
                control2: CGPoint(x: 276.917 * sx, y: 67.5917 * sy)
            )
            path.addCurve(
                to: CGPoint(x: 273.442 * sx, y: 66.4167 * sy),
                control1: CGPoint(x: 275.65 * sx, y: 66.65 * sy),
                control2: CGPoint(x: 274.7 * sx, y: 66.4167 * sy)
            )
            path.addLine(to: CGPoint(x: 269.792 * sx, y: 66.4167 * sy))
            path.addLine(to: CGPoint(x: 269.792 * sx, y: 76.125 * sy))
            path.addLine(to: CGPoint(x: 271.717 * sx, y: 76.125 * sy))
            path.closeSubpath()

            // Subpath 7 — Trademark "M" detail
            path.move(to: CGPoint(x: 271.683 * sx, y: 71.1833 * sy))
            path.addLine(to: CGPoint(x: 271.683 * sx, y: 67.9167 * sy))
            path.addLine(to: CGPoint(x: 273.275 * sx, y: 67.9167 * sy))
            path.addCurve(
                to: CGPoint(x: 275.333 * sx, y: 69.55 * sy),
                control1: CGPoint(x: 274.65 * sx, y: 67.9167 * sy),
                control2: CGPoint(x: 275.333 * sx, y: 68.4583 * sy)
            )
            path.addCurve(
                to: CGPoint(x: 274.933 * sx, y: 70.8 * sy),
                control1: CGPoint(x: 275.333 * sx, y: 70.125 * sy),
                control2: CGPoint(x: 275.2 * sx, y: 70.5417 * sy)
            )
            path.addCurve(
                to: CGPoint(x: 273.642 * sx, y: 71.1833 * sy),
                control1: CGPoint(x: 274.675 * sx, y: 71.0583 * sy),
                control2: CGPoint(x: 274.242 * sx, y: 71.1833 * sy)
            )
            path.addLine(to: CGPoint(x: 271.683 * sx, y: 71.1833 * sy))
            path.closeSubpath()
        }
    }
}

#Preview {
    F1LogoShape()
        .fill(Color.f1Accent, style: FillStyle(eoFill: true))
        .aspectRatio(contentMode: .fit)
        .frame(width: 320, height: 80)
        .padding()
        .preferredColorScheme(.dark)
}
