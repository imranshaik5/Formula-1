import SwiftUI

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
            } else if articles.isEmpty {
                emptyView
            } else {
                newsList
            }
        }
        .navigationTitle(Strings.NewsList.title)
        .task {
            await viewModel.loadArticles()
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
            LazyVStack(spacing: 12) {
                ForEach(Array(articles.enumerated()), id: \.element.id) { index, article in
                    newsCard(article, index: index)
                }
            }
            .padding(12)
        }
        .background(F1Theme.background)
    }

    private func newsCard(_ article: NewsArticle, index: Int) -> some View {
        GlassCard {
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    sourceBadge(article.source)
                    Spacer()
                    Text(article.relativeDate)
                        .font(F1Theme.caption)
                        .foregroundColor(.f1TextSecondary)
                }

                Text(article.title)
                    .font(F1Theme.headline)
                    .foregroundColor(.white)
                    .lineLimit(2)

                if !article.description.isEmpty {
                    Text(article.description)
                        .font(F1Theme.subheadline)
                        .foregroundColor(.f1TextSecondary)
                        .lineLimit(4)
                }

                if let summary = summaries[article.id] {
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
        }
        .transition(.move(edge: .trailing).combined(with: .opacity))
        .animation(.spring(response: 0.4, dampingFraction: 0.8).delay(Double(index) * 0.03), value: articles.count)
        .task {
            guard summaries[article.id] == nil else { return }
            summaries[article.id] = Summarizer.extractSummary(from: article.description)
        }
    }

    private func sourceBadge(_ source: String) -> some View {
        Text(source)
            .font(F1Theme.caption)
            .fontWeight(.semibold)
            .foregroundColor(.f1Accent)
            .padding(.horizontal, 8)
            .padding(.vertical, 3)
            .background(F1Theme.accentRed.opacity(0.15))
            .clipShape(Capsule())
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
