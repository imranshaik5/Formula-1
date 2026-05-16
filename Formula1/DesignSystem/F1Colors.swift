import SwiftUI

enum F1TeamColor {
    case mclaren
    case ferrari
    case redBull
    case mercedes
    case astonMartin
    case alpine
    case racingBulls
    case williams
    case sauber
    case haas
    case cadillac
    case audi

    var primary: Color {
        switch self {
        case .mclaren: return Color(hex: "F47600")
        case .ferrari: return Color(hex: "ED1131")
        case .redBull: return Color(hex: "4781D7")
        case .mercedes: return Color(hex: "00D7B6")
        case .astonMartin: return Color(hex: "229971")
        case .alpine: return Color(hex: "00A1E8")
        case .racingBulls: return Color(hex: "6C98FF")
        case .williams: return Color(hex: "1868DB")
        case .sauber: return Color(hex: "01C00E")
        case .haas: return Color(hex: "9C9FA2")
        case .cadillac: return Color(hex: "1A1A2E")
        case .audi: return Color(hex: "1A1A1A")
        }
    }

    static func forTeam(_ name: String) -> Color {
        let lower = name.lowercased()
        if lower.contains("mclaren") { return Self.mclaren.primary }
        if lower.contains("ferrari") { return Self.ferrari.primary }
        if lower.contains("red bull") || lower.contains("redbull") { return Self.redBull.primary }
        if lower.contains("mercedes") { return Self.mercedes.primary }
        if lower.contains("aston martin") { return Self.astonMartin.primary }
        if lower.contains("alpine") { return Self.alpine.primary }
        if lower.contains("racing bulls") || lower.contains("vcarb") || lower.contains("rb ") || lower == "rb" { return Self.racingBulls.primary }
        if lower.contains("williams") { return Self.williams.primary }
        if lower.contains("sauber") || lower.contains("stake") || lower.contains("kick") { return Self.sauber.primary }
        if lower.contains("haas") || lower.contains("moneygram") || lower.contains("haas f1") { return Self.haas.primary }
        if lower.contains("cadillac") { return Self.cadillac.primary }
        if lower.contains("audi") { return Self.audi.primary }
        return Color(hex: "E10600")
    }
}

extension Color {
    static func f1Team(_ name: String) -> Color {
        F1TeamColor.forTeam(name)
    }

    static let f1Background = F1Theme.background
    static let f1Card = F1Theme.cardBackground
    static let f1CardSecondary = F1Theme.cardBackgroundSecondary
    static let f1TextSecondary = F1Theme.textSecondary
    static let f1Accent = F1Theme.accentRed
    static let f1BackgroundDeep = F1Theme.backgroundDeep
    static let f1BackgroundDarker = F1Theme.backgroundDarker
    static let f1NeonGreen = F1Theme.neonGreen
    static let f1TextMuted = F1Theme.textMuted
    static let f1PurpleAccent = F1Theme.purpleAccent
    static let f1OrangeAccent = F1Theme.orangeAccent
    static let f1OrangeLight = F1Theme.orangeLight
    static let f1GoldLight = F1Theme.goldLight
}
