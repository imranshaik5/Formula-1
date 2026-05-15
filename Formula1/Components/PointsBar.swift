import SwiftUI

struct PointsBar: View {
    let points: Int
    let maxPoints: Int
    let color: Color

    var body: some View {
        GeometryReader { geo in
            ZStack(alignment: .leading) {
                RoundedRectangle(cornerRadius: 4)
                    .fill(Color.white.opacity(0.1))
                    .frame(height: 8)

                RoundedRectangle(cornerRadius: 4)
                    .fill(color)
                    .frame(width: geo.size.width * min(CGFloat(points) / CGFloat(max(maxPoints, 1)), 1), height: 8)
            }
        }
        .frame(height: 8)
    }
}
