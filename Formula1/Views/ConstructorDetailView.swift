import SwiftUI

struct ConstructorDetailView: View {
    let standing: ConstructorStanding

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                heroSection
                statsSection
            }
            .padding(.vertical)
        }
        .background(F1Theme.background)
        .navigationTitle(standing.constructor.name)
        .navigationBarTitleDisplayMode(.inline)
    }

    private var heroSection: some View {
        VStack(spacing: 16) {
            RoundedRectangle(cornerRadius: 20)
                .fill(standing.constructor.color.opacity(0.15))
                .frame(width: 100, height: 100)
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(standing.constructor.color, lineWidth: 2)
                )
                .overlay(
                    Text(abbreviation)
                        .font(.system(size: 36, weight: .bold, design: .rounded))
                        .foregroundColor(standing.constructor.color)
                )

            Text(standing.constructor.name)
                .font(F1Theme.largeTitle)
                .foregroundColor(.white)

            HStack(spacing: 8) {
                Text("P\(standing.position) in standings")
                    .font(F1Theme.subheadline)
                    .foregroundColor(.f1TextSecondary)

                Text("•")
                    .foregroundColor(.f1TextSecondary)

                Text(standing.constructor.nationality)
                    .font(F1Theme.subheadline)
                    .foregroundColor(.f1TextSecondary)
            }
        }
        .padding(.horizontal)
    }

    private var statsSection: some View {
        GlassCard {
            VStack(spacing: 16) {
                Text("Season Statistics")
                    .font(F1Theme.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity, alignment: .leading)

                HStack(spacing: 0) {
                    statItem(label: "Position", value: "\(standing.position)", icon: "number")
                    Spacer()
                    statItem(label: "Points", value: "\(standing.points)", icon: "star.fill")
                    Spacer()
                    statItem(label: "Wins", value: "\(standing.wins)", icon: "trophy.fill")
                }

                VStack(alignment: .leading, spacing: 4) {
                    Text("Points Progress")
                        .font(F1Theme.caption)
                        .foregroundColor(.f1TextSecondary)

                    PointsBar(
                        points: standing.points,
                        maxPoints: max(standing.points, 500),
                        color: standing.constructor.color
                    )
                }
            }
        }
        .padding(.horizontal)
    }

    private func statItem(label: String, value: String, icon: String) -> some View {
        VStack(spacing: 4) {
            Image(systemName: icon)
                .font(.title3)
                .foregroundColor(.f1TextSecondary)
            Text(value)
                .font(F1Theme.statistic)
                .foregroundColor(.white)
            Text(label)
                .font(F1Theme.caption)
                .foregroundColor(.f1TextSecondary)
        }
    }

    private var abbreviation: String {
        let words = standing.constructor.name.split(separator: " ")
        if words.count == 1 {
            return String(words.first!.prefix(3)).uppercased()
        }
        return words.compactMap { $0.first }.map { String($0) }.joined().uppercased().prefix(3).description
    }
}
