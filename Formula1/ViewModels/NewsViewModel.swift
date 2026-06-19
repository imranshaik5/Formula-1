import Foundation

@MainActor
final class NewsViewModel: ObservableObject {
    @Published var state: LoadState<[NewsArticle]> = .idle
    @Published var lastUpdated: Date?
    @Published var isRefreshing = false

    private let newsService: NewsServiceProtocol
    private var refreshTask: Task<Void, Never>?
    private let cacheKey = "cached_news_articles"

    init(newsService: NewsServiceProtocol = NewsService()) {
        self.newsService = newsService
        loadCached()
    }

    func loadArticles() async {
        state = .loading
        await fetch()
    }

    func refresh() async {
        isRefreshing = true
        await fetch()
        isRefreshing = false
    }

    func startAutoRefresh(interval: TimeInterval = 120) {
        refreshTask?.cancel()
        refreshTask = Task { [weak self] in
            while !Task.isCancelled {
                try? await Task.sleep(for: .seconds(interval))
                guard !Task.isCancelled else { break }
                await self?.refresh()
            }
        }
    }

    func stopAutoRefresh() {
        refreshTask?.cancel()
        refreshTask = nil
    }

    private func fetch() async {
        do {
            let articles = try await newsService.fetchArticles()
            state = .loaded(articles)
            lastUpdated = Date()
            cache(articles)
        } catch {
            if state.value == nil {
                state = .error(error)
            }
        }
    }

    private func cache(_ articles: [NewsArticle]) {
        guard let data = try? JSONEncoder().encode(articles) else { return }
        UserDefaults.standard.set(data, forKey: cacheKey)
    }

    private func loadCached() {
        guard let data = UserDefaults.standard.data(forKey: cacheKey),
              let articles = try? JSONDecoder().decode([NewsArticle].self, from: data) else { return }
        state = .loaded(articles)
        lastUpdated = Date()
    }
}
