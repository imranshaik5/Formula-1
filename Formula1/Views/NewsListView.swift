import SwiftUI

struct NewsListView: View {
    @StateObject private var viewModel: NewsViewModel

    @MainActor
    init(viewModel: NewsViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        Group {
            if viewModel.isLoading && viewModel.articles.isEmpty {
                loadingView
            } else if viewModel.articles.isEmpty {
                emptyView
            } else {
                newsList
            }
        }
        .navigationTitle("News")
        .task {
            await viewModel.loadArticles()
        }
    }

    private var loadingView: some View {
        VStack(spacing: 16) {
            ProgressView()
                .tint(.f1Accent)
                .scaleEffect(1.5)
            Text("Loading news...")
                .font(F1Theme.subheadline)
                .foregroundColor(.f1TextSecondary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(F1Theme.background)
    }

    private var emptyView: some View {
        ContentUnavailableView(
            "No News",
            systemImage: "newspaper",
            description: Text("Check back later for F1 news updates.")
        )
        .foregroundColor(.f1TextSecondary)
        .background(F1Theme.background)
    }

    private var newsList: some View {
        ScrollView {
            LazyVStack(spacing: 12) {
                ForEach(Array(viewModel.articles.enumerated()), id: \.element.id) { index, article in
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
                        .lineLimit(2)
                }
            }
        }
        .transition(.move(edge: .trailing).combined(with: .opacity))
        .animation(.spring(response: 0.4, dampingFraction: 0.8).delay(Double(index) * 0.03), value: viewModel.articles.count)
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
