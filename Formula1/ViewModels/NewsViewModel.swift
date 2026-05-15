import Foundation

@MainActor
final class NewsViewModel: ObservableObject {
    @Published private(set) var articles: [NewsArticle] = []
    @Published private(set) var isLoading = false
    @Published private(set) var error: Error?

    private let newsService: NewsServiceProtocol

    init(newsService: NewsServiceProtocol = NewsService()) {
        self.newsService = newsService
    }

    func loadArticles() async {
        isLoading = true
        error = nil
        do {
            articles = try await newsService.fetchArticles()
        } catch {
            self.error = error
        }
        isLoading = false
    }
}
