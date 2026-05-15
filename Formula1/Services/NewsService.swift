import Foundation

final class NewsService: NewsServiceProtocol {
    func fetchArticles() async throws -> [NewsArticle] {
        MockData.newsArticles
    }
}
