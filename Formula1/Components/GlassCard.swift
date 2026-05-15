import SwiftUI

struct GlassCard<Content: View>: View {
    let content: Content

    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }

    var body: some View {
        content
            .padding(F1Theme.cardPadding)
            .background(.ultraThinMaterial)
            .background(F1Theme.cardBackground.opacity(0.3))
            .clipShape(RoundedRectangle(cornerRadius: F1Theme.cornerRadius))
            .overlay(
                RoundedRectangle(cornerRadius: F1Theme.cornerRadius)
                    .stroke(Color.white.opacity(0.1), lineWidth: 1)
            )
            .shadow(color: .black.opacity(0.3), radius: 10, x: 0, y: 5)
    }
}
