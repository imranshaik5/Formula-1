import Foundation

@MainActor
final class NewsViewModel: ObservableObject {
    @Published var state: LoadState<[NewsArticle]> = .idle

    private let newsService: NewsServiceProtocol

    init(newsService: NewsServiceProtocol = NewsService()) {
        self.newsService = newsService
    }

    func loadArticles() async {
        state = .loading
        do {
            let articles = try await newsService.fetchArticles()
            state = .loaded(articles)
        } catch {
            state = .error(error)
        }
    }
}
