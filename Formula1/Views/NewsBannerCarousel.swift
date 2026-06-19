import SwiftUI
import Kingfisher

struct NewsBannerCarousel: View {
    @StateObject private var viewModel = NewsViewModel()
    @State private var currentIndex = 0

    private let interval: TimeInterval = 4

    private var articles: [NewsArticle] {
        Array((viewModel.state.value ?? []).prefix(5))
    }

    var body: some View {
        if articles.isEmpty {
            EmptyView()
        } else {
            TabView(selection: $currentIndex) {
                ForEach(Array(articles.enumerated()), id: \.element.id) { index, article in
                    slide(for: article)
                        .tag(index)
                }
            }
            .frame(height: 160)
            .tabViewStyle(.page(indexDisplayMode: .always))
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .padding(.horizontal, 16)
            .task { @MainActor in
                guard viewModel.state.value == nil else { return }
                await viewModel.loadArticles()
                await startAutoScroll()
            }
        }
    }

    private func startAutoScroll() async {
        while !Task.isCancelled {
            try? await Task.sleep(for: .seconds(interval))
            guard !Task.isCancelled, !articles.isEmpty else { break }
            await MainActor.run {
                withAnimation(.easeInOut(duration: 0.5)) {
                    currentIndex = (currentIndex + 1) % articles.count
                }
            }
        }
    }

    @ViewBuilder
    private func slide(for article: NewsArticle) -> some View {
        Button {
            guard let url = URL(string: article.url) else { return }
            UIApplication.shared.open(url)
        } label: {
            ZStack {
                if let imageURL = article.imageURL, let url = URL(string: imageURL) {
                    KFImage(url)
                        .placeholder { imagePlaceholder }
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    imagePlaceholder
                }

                Color.black.opacity(0.4)

                VStack(alignment: .leading, spacing: 6) {
                    Text(article.source)
                        .font(.system(size: 10, weight: .semibold))
                        .foregroundColor(.f1Accent)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 2)
                        .background(.ultraThinMaterial)
                        .clipShape(Capsule())

                    Text(article.title)
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(.white)
                        .lineLimit(2)
                        .multilineTextAlignment(.center)
                }
                .padding(.horizontal, 16)
            }
        }
        .buttonStyle(.plain)
    }

    private var imagePlaceholder: some View {
        Rectangle()
            .fill(F1Theme.cardBackground)
            .overlay {
                Image(systemName: "newspaper")
                    .foregroundColor(.f1TextSecondary)
            }
    }
}
