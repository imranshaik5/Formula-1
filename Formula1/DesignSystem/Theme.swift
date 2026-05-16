import SwiftUI

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3:
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6:
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8:
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(.sRGB, red: Double(r) / 255, green: Double(g) / 255, blue: Double(b) / 255, opacity: Double(a) / 255)
    }
}

enum F1Theme {
    static let background = Color(hex: "0A0A0F")
    static let cardBackground = Color(hex: "1A1A2E")
    static let cardBackgroundSecondary = Color(hex: "242438")
    static let textPrimary = Color.white
    static let textSecondary = Color(hex: "8E8E98")
    static let accentRed = Color(hex: "E10600")
    static let gold = Color(hex: "FFD700")
    static let silver = Color(hex: "C0C0C0")
    static let bronze = Color(hex: "CD7F32")

    static let backgroundDeep = Color(hex: "050508")
    static let backgroundDarker = Color(hex: "050505")
    static let neonGreen = Color(hex: "39FF14")
    static let textMuted = Color(hex: "5A5A64")
    static let purpleAccent = Color(hex: "B026FF")
    static let orangeAccent = Color(hex: "FF4400")
    static let orangeLight = Color(hex: "FF6633")
    static let goldLight = Color(hex: "FFCC00")

    static let largeTitle = Font.system(.largeTitle, design: .rounded).weight(.bold)
    static let title = Font.system(.title, design: .rounded).weight(.bold)
    static let headline = Font.system(.headline, design: .rounded).weight(.semibold)
    static let subheadline = Font.system(.subheadline, design: .rounded)
    static let caption = Font.system(.caption, design: .rounded)
    static let statistic = Font.system(.title, design: .rounded).weight(.bold)

    static let cornerRadius: CGFloat = 16
    static let smallCornerRadius: CGFloat = 8
    static let cardPadding: CGFloat = 16
    static let standardSpacing: CGFloat = 12
}
