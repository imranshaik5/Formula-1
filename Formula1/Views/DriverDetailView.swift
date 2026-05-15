import SwiftUI
import Kingfisher

struct DriverDetailView: View {
    @StateObject private var viewModel: DriverDetailViewModel

    @MainActor
    init(viewModel: DriverDetailViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                heroSection
                statsSection
                if !viewModel.bestResults.isEmpty {
                    bestMomentsSection
                }
                if !viewModel.careerResults.isEmpty {
                    careerResultsSection
                }
                videoSection
            }
            .padding(.vertical)
        }
        .background(F1Theme.background)
        .navigationTitle(viewModel.driver.name)
        .navigationBarTitleDisplayMode(.inline)
        .task {
            await viewModel.loadDriverDetails()
        }
    }

    // MARK: - Hero

    private var heroSection: some View {
        VStack(spacing: 16) {
            DriverPhotoView(
                driverName: viewModel.driver.name,
                teamColor: Color.f1Team(viewModel.driver.team.name),
                size: 120,
                driverCode: viewModel.driver.code
            )

            Text(viewModel.driver.name)
                .font(F1Theme.largeTitle)
                .foregroundColor(.white)

            HStack(spacing: 8) {
                Text(nationalityFlag(viewModel.driver.nationality))
                    .font(.title3)

                Text("•")
                    .foregroundColor(.f1TextSecondary)

                Text(viewModel.driver.team.name)
                    .font(F1Theme.subheadline)
                    .foregroundColor(Color.f1Team(viewModel.driver.team.name))

                Text("•")
                    .foregroundColor(.f1TextSecondary)

                Text("#\(viewModel.driver.number)")
                    .font(F1Theme.subheadline)
                    .foregroundColor(.f1TextSecondary)
            }
        }
        .padding(.horizontal)
    }

    // MARK: - Stats

    private var statsSection: some View {
        GlassCard {
            VStack(spacing: 16) {
                Text("Season Statistics")
                    .font(F1Theme.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity, alignment: .leading)

                VStack(spacing: 12) {
                    HStack {
                        statItem(label: "Position", value: "\(viewModel.driver.position)", icon: "number")
                        Spacer()
                        statItem(label: "Points", value: "\(viewModel.driver.points)", icon: "star.fill")
                        Spacer()
                        statItem(label: "Wins", value: "\(viewModel.driver.wins)", icon: "trophy.fill")
                        Spacer()
                        statItem(label: "Races", value: "\(viewModel.careerResults.count)", icon: "flag.checkered")
                    }

                    VStack(alignment: .leading, spacing: 4) {
                        Text("Points Progress")
                            .font(F1Theme.caption)
                            .foregroundColor(.f1TextSecondary)

                        PointsBar(
                            points: viewModel.driver.points,
                            maxPoints: max(viewModel.driver.points, 300),
                            color: Color.f1Team(viewModel.driver.team.name)
                        )
                    }
                }
            }
        }
        .padding(.horizontal)
    }

    // MARK: - Best Moments

    private var bestMomentsSection: some View {
        GlassCard {
            VStack(spacing: 12) {
                HStack {
                    Image(systemName: "trophy.fill")
                        .font(.caption)
                        .foregroundColor(.yellow)
                    Text("BEST MOMENTS")
                        .font(.system(size: 9, weight: .bold, design: .default))
                        .foregroundColor(.white.opacity(0.4))
                        .tracking(3)
                    Spacer()
                }

                ForEach(viewModel.bestResults.indices, id: \.self) { i in
                    let entry = viewModel.bestResults[i]
                    let pos = entry.driver.position
                    let color: Color = pos == 1 ? .yellow : pos == 2 ? F1Theme.silver : F1Theme.bronze
                    HStack(spacing: 12) {
                        Text("P\(pos)")
                            .font(.system(size: 13, weight: .bold, design: .monospaced))
                            .foregroundColor(color)
                            .frame(width: 32, alignment: .leading)

                        Text(entry.driver.team.name)
                            .font(.system(size: 12, weight: .medium))
                            .foregroundColor(.white.opacity(0.5))

                        Spacer()

                        if let time = entry.time {
                            Text(time)
                                .font(.system(size: 10, weight: .regular, design: .monospaced))
                                .foregroundColor(.f1TextSecondary)
                        }

                        Text("+\(entry.points) pts")
                            .font(.system(size: 10, weight: .bold, design: .monospaced))
                            .foregroundColor(color.opacity(0.8))
                            .frame(width: 52, alignment: .trailing)
                    }
                    .padding(.vertical, 4)
                    .padding(.horizontal, 8)
                    .background(color.opacity(0.06))
                    .clipShape(RoundedRectangle(cornerRadius: 8))

                    if i < viewModel.bestResults.count - 1 {
                        Divider().background(.white.opacity(0.04))
                    }
                }
            }
        }
        .padding(.horizontal)
    }

    // MARK: - Career Results

    private var careerResultsSection: some View {
        GlassCard {
            VStack(spacing: 12) {
                HStack {
                    Image(systemName: "clock.arrow.circlepath")
                        .font(.caption)
                        .foregroundColor(.f1Accent)
                    Text("2026 SEASON RESULTS")
                        .font(.system(size: 9, weight: .bold, design: .default))
                        .foregroundColor(.white.opacity(0.4))
                        .tracking(3)
                    Spacer()
                }

                ForEach(viewModel.careerResults.indices, id: \.self) { i in
                    let entry = viewModel.careerResults[i]
                    let pos = entry.driver.position
                    HStack(spacing: 10) {
                        Text("R\(i + 1)")
                            .font(.system(size: 10, weight: .medium, design: .monospaced))
                            .foregroundColor(.white.opacity(0.3))
                            .frame(width: 20, alignment: .leading)

                        Text("P\(pos)")
                            .font(.system(size: 12, weight: .bold, design: .monospaced))
                            .foregroundColor(posColor(pos))
                            .frame(width: 28, alignment: .leading)

                        Text(entry.driver.team.name)
                            .font(.system(size: 11, weight: .medium))
                            .foregroundColor(.white.opacity(0.5))
                            .lineLimit(1)

                        Spacer()

                        Text("\(entry.points) pts")
                            .font(.system(size: 10, weight: .bold, design: .monospaced))
                            .foregroundColor(.white.opacity(0.4))
                    }
                    .padding(.vertical, 3)

                    if i < viewModel.careerResults.count - 1 {
                        Divider().background(.white.opacity(0.03))
                    }
                }
            }
        }
        .padding(.horizontal)
    }

    // MARK: - Videos

    private var videoSection: some View {
        VStack(spacing: 12) {
            sectionHeader(icon: "play.rectangle.fill", title: "BEST MOMENTS VIDEOS", color: .f1Accent)
                .padding(.horizontal, 20)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(viewModel.videoCategories, id: \.key) { cat in
                        videoCard(cat: cat)
                    }
                }
                .padding(.horizontal, 20)
            }
        }
    }

    private func videoCard(cat: (key: String, title: String, query: String)) -> some View {
        let thumb = viewModel.thumbnailURL(for: cat.key)
        let vidURL = viewModel.videoURL(for: cat.key)
        return Button {
            if let url = vidURL {
                UIApplication.shared.open(url)
            } else {
                let encoded = cat.query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
                guard let url = URL(string: "https://www.youtube.com/results?search_query=\(encoded)") else { return }
                UIApplication.shared.open(url)
            }
        } label: {
            VStack(alignment: .leading, spacing: 6) {
                ZStack {
                    if let thumb {
                        KFImage(thumb)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 180, height: 100)
                            .clipped()
                    } else {
                        RoundedRectangle(cornerRadius: 10)
                            .fill(
                                LinearGradient(
                                    colors: [Color.f1Team(viewModel.driver.team.name).opacity(0.5), .blue.opacity(0.15)],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                    }

                    Image(systemName: "play.circle.fill")
                        .font(.system(size: 34))
                        .foregroundColor(.white.opacity(0.85))
                        .shadow(color: .black.opacity(0.4), radius: 6)
                }
                .frame(width: 180, height: 100)
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(.white.opacity(0.08), lineWidth: 1)
                )

                Text(cat.title)
                    .font(.system(size: 11, weight: .medium))
                    .foregroundColor(.white)
                    .lineLimit(2)
                    .frame(width: 180, alignment: .leading)
            }
        }
    }

    private func sectionHeader(icon: String, title: String, color: Color) -> some View {
        HStack(spacing: 6) {
            Image(systemName: icon)
                .font(.caption)
                .foregroundColor(color)
            Text(title)
                .font(.system(size: 9, weight: .bold, design: .default))
                .foregroundColor(.white.opacity(0.4))
                .tracking(3)
            Spacer()
        }
    }

    // MARK: - Helpers

    private func posColor(_ pos: Int) -> Color {
        switch pos {
        case 1: return .yellow
        case 2: return F1Theme.silver
        case 3: return F1Theme.bronze
        case 4...10: return .white.opacity(0.8)
        default: return .white.opacity(0.4)
        }
    }

    private func nationalityFlag(_ nationality: String) -> String {
        let mapping: [String: String] = [
            "Dutch": "NL", "British": "GB", "Monegasque": "MC", "Australian": "AU",
            "Spanish": "ES", "Mexican": "MX", "Canadian": "CA", "French": "FR",
            "Japanese": "JP", "Thai": "TH", "American": "US", "Finnish": "FI",
            "Chinese": "CN", "Danish": "DK", "German": "DE", "Italian": "IT",
            "Brazilian": "BR", "Russian": "RU", "Indian": "IN", "Belgian": "BE",
            "Swiss": "CH", "Swedish": "SE", "Polish": "PL", "Austrian": "AT",
            "New Zealander": "NZ", "Irish": "IE", "Portuguese": "PT", "Hungarian": "HU",
            "Argentinian": "AR", "Colombian": "CO", "South African": "ZA",
            "Venezuelan": "VE", "Malaysian": "MY", "Indonesian": "ID",
            "Czech": "CZ", "Chilean": "CL",
        ]
        let code = mapping[nationality] ?? nationality
        let base: UInt32 = 127397
        var s = ""
        for scalar in code.uppercased().unicodeScalars {
            if let flagScalar = UnicodeScalar(base + scalar.value) {
                s.append(String(flagScalar))
            }
        }
        return s
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
}
