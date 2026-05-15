import SwiftUI

struct PositionBadge: View {
    let position: Int
    let color: Color
    let size: CGFloat

    init(position: Int, color: Color = .f1Accent, size: CGFloat = 40) {
        self.position = position
        self.color = color
        self.size = size
    }

    var body: some View {
        ZStack {
            Circle()
                .fill(color.opacity(0.15))
                .frame(width: size, height: size)

            Circle()
                .stroke(color, lineWidth: 2)
                .frame(width: size, height: size)

            Text("\(position)")
                .font(.system(size: size * 0.4, weight: .bold, design: .rounded))
                .foregroundColor(color)
        }
    }
}
