import SwiftUI
import Kingfisher

struct NewsListView: View {
    @StateObject private var viewModel: NewsViewModel
    @State private var summaries: [String: String] = [:]

    @MainActor
    init(viewModel: NewsViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    private var articles: [NewsArticle] { viewModel.state.value ?? [] }

    var body: some View {
        Group {
            if viewModel.state.isLoading && articles.isEmpty {
                loadingView
            } else if case .error = viewModel.state, articles.isEmpty {
                errorView
            } else if articles.isEmpty {
                emptyView
            } else {
                newsList
            }
        }
        .navigationTitle(Strings.NewsList.title)
        .task {
            if articles.isEmpty {
                await viewModel.loadArticles()
            }
            viewModel.startAutoRefresh()
        }
        .onDisappear {
            viewModel.stopAutoRefresh()
        }
    }

    private var loadingView: some View {
        VStack(spacing: 16) {
            ProgressView()
                .tint(.f1Accent)
                .scaleEffect(1.5)
            Text(Strings.NewsList.loading)
                .font(F1Theme.subheadline)
                .foregroundColor(.f1TextSecondary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(F1Theme.background)
    }

    private var errorView: some View {
        ContentUnavailableView(
            Strings.NewsList.errorTitle,
            systemImage: "wifi.slash",
            description: Text(Strings.NewsList.errorDescription)
        )
        .foregroundColor(.f1TextSecondary)
        .background(F1Theme.background)
        .overlay(alignment: .bottom) {
            Button(Strings.NewsList.retry) {
                Task { await viewModel.loadArticles() }
            }
            .buttonStyle(.borderedProminent)
            .tint(.f1Accent)
            .padding(.bottom, 40)
        }
    }

    private var emptyView: some View {
        ContentUnavailableView(
            Strings.NewsList.emptyTitle,
            systemImage: "newspaper",
            description: Text(Strings.NewsList.emptyDescription)
        )
        .foregroundColor(.f1TextSecondary)
        .background(F1Theme.background)
    }

    private var newsList: some View {
        ScrollView {
            lastUpdatedBar
            refreshIndicator
            LazyVStack(spacing: 12) {
                ForEach(Array(articles.enumerated()), id: \.element.id) { index, article in
                    NewsCardView(article: article, summary: summaries[article.id])
                        .transition(.move(edge: .trailing).combined(with: .opacity))
                        .animation(.spring(response: 0.4, dampingFraction: 0.8).delay(Double(index) * 0.03), value: articles.count)
                        .task {
                            guard summaries[article.id] == nil else { return }
                            summaries[article.id] = Summarizer.extractSummary(from: article.description)
                        }
                }
            }
            .padding(12)
        }
        .background(F1Theme.background)
        .refreshable {
            await viewModel.refresh()
        }
    }

    @ViewBuilder
    private var lastUpdatedBar: some View {
        if let lastUpdated = viewModel.lastUpdated {
            HStack {
                Spacer()
                Text("\(Strings.NewsList.lastUpdated) • \(lastUpdated.formatted(date: .omitted, time: .shortened))")
                    .font(.system(size: 11))
                    .foregroundColor(.f1TextSecondary.opacity(0.6))
                Spacer()
            }
            .padding(.top, 8)
        }
    }

    @ViewBuilder
    private var refreshIndicator: some View {
        if viewModel.isRefreshing {
            ProgressView()
                .tint(.f1Accent)
                .padding(.vertical, 8)
        }
    }
}

private struct NewsCardView: View {
    let article: NewsArticle
    let summary: String?

    var body: some View {
        Button {
            guard let url = URL(string: article.url) else { return }
            UIApplication.shared.open(url)
        } label: {
            GlassCard {
                VStack(alignment: .leading, spacing: 8) {
                    cardHeader
                    cardImage
                    cardTitle
                    cardDescription
                    cardSummary
                    cardFooter
                }
            }
        }
        .buttonStyle(.plain)
    }

    private var cardHeader: some View {
        HStack {
            sourceBadge
            Spacer()
            Text(article.relativeDate)
                .font(F1Theme.caption)
                .foregroundColor(.f1TextSecondary)
        }
    }

    private var sourceBadge: some View {
        Text(article.source)
            .font(F1Theme.caption)
            .fontWeight(.semibold)
            .foregroundColor(.f1Accent)
            .padding(.horizontal, 8)
            .padding(.vertical, 3)
            .background(F1Theme.accentRed.opacity(0.15))
            .clipShape(Capsule())
    }

    @ViewBuilder
    private var cardImage: some View {
        if let imageURL = article.imageURL, let url = URL(string: imageURL) {
            KFImage(url)
                .placeholder { imagePlaceholder }
                .resizable()
                .aspectRatio(16/9, contentMode: .fill)
                .clipShape(RoundedRectangle(cornerRadius: 10))
        }
    }

    private var imagePlaceholder: some View {
        Rectangle()
            .fill(F1Theme.cardBackground)
            .overlay {
                Image(systemName: "photo")
                    .foregroundColor(.f1TextSecondary)
            }
    }

    private var cardTitle: some View {
        Text(article.title)
            .font(F1Theme.headline)
            .foregroundColor(.white)
            .lineLimit(2)
            .multilineTextAlignment(.leading)
    }

    @ViewBuilder
    private var cardDescription: some View {
        if !article.description.isEmpty {
            Text(article.description)
                .font(F1Theme.subheadline)
                .foregroundColor(.f1TextSecondary)
                .lineLimit(4)
                .multilineTextAlignment(.leading)
        }
    }

    @ViewBuilder
    private var cardSummary: some View {
        if let summary {
            HStack(spacing: 6) {
                Image(systemName: "sparkle.magnifyingglass")
                    .font(.system(size: 10))
                    .foregroundColor(.f1Accent)
                Text(summary)
                    .font(.system(.caption, design: .rounded))
                    .foregroundColor(.f1TextSecondary.opacity(0.8))
                    .lineLimit(2)
            }
            .padding(8)
            .background(.ultraThinMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 8))
        }
    }

    private var cardFooter: some View {
        HStack(spacing: 4) {
            Image(systemName: "safari")
                .font(.system(size: 10))
            Text(Strings.NewsList.openArticle)
                .font(.system(.caption, design: .rounded))
        }
        .foregroundColor(.f1Accent)
    }
}

struct NewsListView_Previews: PreviewProvider {
    static var previews: some View {
        PreviewWrapper {
            NavigationStack {
                NewsListView(viewModel: .preview)
            }
        }
    }
}
