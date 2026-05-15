import SwiftUI

struct ConstructorColorBar: View {
    let color: Color
    let height: CGFloat

    init(color: Color, height: CGFloat = 40) {
        self.color = color
        self.height = height
    }

    var body: some View {
        RoundedRectangle(cornerRadius: 2)
            .fill(color)
            .frame(width: 4, height: height)
    }
}
