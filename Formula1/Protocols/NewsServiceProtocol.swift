import Foundation

protocol NewsServiceProtocol {
    func fetchArticles() async throws -> [NewsArticle]
}
