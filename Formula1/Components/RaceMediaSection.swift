import SwiftUI

struct RaceMediaSection: View {
    let raceName: String

    var body: some View {
        let categories: [(title: String, icon: String, query: String)] = [
            (Strings.RaceDetail.mediaHighlights, "play.rectangle.fill", "highlights"),
            (Strings.RaceDetail.mediaTopRated, "star.fill", "race review"),
            (Strings.RaceDetail.mediaViral, "flame.fill", "viral moments"),
        ]
        return VStack(spacing: 12) {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 8) {
                    ForEach(categories.indices, id: \.self) { i in
                        Text(categories[i].title)
                            .font(.system(size: 11, weight: .semibold))
                            .foregroundColor(.white)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(Capsule().fill(Color.f1Accent))
                    }
                }
                .padding(.horizontal, 20)
            }

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(0..<5) { i in
                        mediaCard(index: i)
                    }
                }
                .padding(.horizontal, 20)
            }
        }
    }

    private func mediaCard(index: Int) -> some View {
        Button {
            let query = "F1 \(raceName) 2026 highlights"
                .addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
            guard let url = URL(string: "https://www.youtube.com/results?search_query=\(query)") else { return }
            UIApplication.shared.open(url)
        } label: {
            VStack(alignment: .leading, spacing: 6) {
                ZStack {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(
                            LinearGradient(
                                colors: [.f1Accent.opacity(0.4 + Double(index) * 0.08), .blue.opacity(0.15)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 180, height: 100)

                    Image(systemName: "play.circle.fill")
                        .font(.system(size: 34))
                        .foregroundColor(.white.opacity(0.85))
                        .shadow(color: .black.opacity(0.4), radius: 6)
                }
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(.white.opacity(0.08), lineWidth: 1)
                )

                Text(mediaTitles[index])
                    .font(.system(size: 11, weight: .medium))
                    .foregroundColor(.white)
                    .lineLimit(2)
                    .frame(width: 180, alignment: .leading)

                HStack(spacing: 4) {
                    Image(systemName: "play.fill")
                        .font(.system(size: 8))
                    Text("\(Int.random(in: 5..<50) * 1000)")
                        .font(.system(size: 9, weight: .regular, design: .monospaced))
                }
                .foregroundColor(.f1TextSecondary)
            }
        }
    }

    private var mediaTitles: [String] {
        Strings.RaceDetail.mediaTitles
    }
}
