import SwiftUI

struct RaceHeaderView: View {
    let raceName: String
    let round: Int
    let country: String

    var body: some View {
        VStack(spacing: 8) {
            Text(Strings.RaceDetail.round(round).uppercased())
                .font(.system(size: 11, weight: .bold, design: .default))
                .foregroundColor(.f1Accent)
                .tracking(3)
                .padding(.horizontal, 12)
                .padding(.vertical, 4)
                .background(.ultraThinMaterial)
                .clipShape(Capsule())

            Text(raceName.uppercased())
                .font(.system(size: 28, weight: .bold, design: .default))
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
                .padding(.horizontal)

            HStack(spacing: 6) {
                Text(countryFlag(country))
                    .font(.title2)
                Text(country)
                    .font(.system(size: 13, weight: .medium, design: .default))
                    .foregroundColor(.white.opacity(0.5))
            }
        }
    }

    private func countryFlag(_ country: String) -> String {
        let flags: [String: String] = [
            "Australia": "🇦🇺", "China": "🇨🇳", "USA": "🇺🇸", "Italy": "🇮🇹",
            "Monaco": "🇲🇨", "Canada": "🇨🇦", "Spain": "🇪🇸", "Austria": "🇦🇹",
            "Great Britain": "🇬🇧", "Hungary": "🇭🇺", "Belgium": "🇧🇪",
            "Netherlands": "🇳🇱", "Singapore": "🇸🇬", "Japan": "🇯🇵",
            "Qatar": "🇶🇦", "Mexico": "🇲🇽", "Brazil": "🇧🇷", "UAE": "🇦🇪",
            "Abu Dhabi": "🇦🇪", "Mexico City": "🇲🇽", "São Paulo": "🇧🇷"
        ]
        return flags[country, default: "🏁"]
    }
}
