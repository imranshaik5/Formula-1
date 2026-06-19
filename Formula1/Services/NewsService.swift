import Foundation
import FeedKit

private enum RSSFeedURL {
    static let theRace = "https://www.the-race.com/rss/"
    static let bbcSport = "https://feeds.bbci.co.uk/sport/formula1/rss.xml"
    static let motorsport = "https://www.motorsport.com/rss/f1/news/"
}

enum NewsServiceError: LocalizedError {
    case invalidResponse
    case allSourcesFailed
    case cancelled

    var errorDescription: String? {
        switch self {
        case .invalidResponse: return Strings.NewsService.errorInvalidResponse
        case .allSourcesFailed: return Strings.NewsService.errorAllSourcesFailed
        case .cancelled: return Strings.NewsService.errorCancelled
        }
    }
}

final class NewsService: NewsServiceProtocol {
    private let session: URLSession
    private let decoder: JSONDecoder

    init(session: URLSession = .shared) {
        self.session = session
        self.decoder = JSONDecoder()
        self.decoder.dateDecodingStrategy = .iso8601
    }

    func fetchArticles() async throws -> [NewsArticle] {
        var allArticles: [NewsArticle] = []
        var lastError: Error?

        for source in RSSSource.allCases {
            do {
                let articles = try await fetchSource(source)
                allArticles.append(contentsOf: articles)
            } catch {
                lastError = error
            }
        }

        if allArticles.isEmpty, let lastError {
            throw lastError
        }

        return allArticles
            .sorted { $0.publishedAt > $1.publishedAt }
            .deduplicated()
    }

    private func fetchSource(_ source: RSSSource) async throws -> [NewsArticle] {
        guard let url = URL(string: source.url) else {
            throw NewsServiceError.invalidResponse
        }

        var request = URLRequest(url: url)
        request.timeoutInterval = 15
        request.setValue(Strings.NewsService.userAgent, forHTTPHeaderField: "User-Agent")

        let (data, _) = try await session.data(for: request)

        guard !data.isEmpty else {
            throw NewsServiceError.invalidResponse
        }

        let parser = FeedParser(data: data)
        let result = parser.parse()

        switch result {
        case .success(let feed):
            let articles = Self.parseFeed(feed, sourceName: source.displayName, filterCategory: source.filterCategory)
            return articles
        case .failure:
            return []
        }
    }

    private static func parseFeed(_ feed: Feed, sourceName: String, filterCategory: String? = nil) -> [NewsArticle] {
        switch feed {
        case .rss(let rssFeed):
            return parseRSSFeed(rssFeed, sourceName: sourceName, filterCategory: filterCategory)
        case .atom(let atomFeed):
            return parseAtomFeed(atomFeed, sourceName: sourceName)
        case .json:
            return []
        }
    }

    private static func parseRSSFeed(_ rssFeed: RSSFeed, sourceName: String, filterCategory: String? = nil) -> [NewsArticle] {
        let feedTitle = rssFeed.title ?? sourceName
        return rssFeed.items?.compactMap { item in
            guard let title = item.title, !title.isEmpty else { return nil }
            if let filterCategory {
                let categories = item.categories?.compactMap { $0.value } ?? []
                guard categories.contains(where: { $0 == filterCategory }) else { return nil }
            }
            let link = item.link ?? ""
            let description = item.description?.strippingHTMLTags ?? ""
            let pubDate = item.pubDate ?? Date()
            let imageURL = extractImageURL(from: item)
            let guid = item.guid?.value ?? link
            return NewsArticle(
                id: guid,
                title: title,
                description: description,
                source: feedTitle,
                url: link,
                publishedAt: pubDate,
                imageURL: imageURL
            )
        } ?? []
    }

    private static func parseAtomFeed(_ atomFeed: AtomFeed, sourceName: String) -> [NewsArticle] {
        let feedTitle = atomFeed.title ?? sourceName
        return atomFeed.entries?.compactMap { entry in
            guard let title = entry.title, !title.isEmpty else { return nil }
            let link = entry.links?.first?.attributes?.href ?? ""
            let description = entry.summary?.value?.strippingHTMLTags ?? entry.content?.value?.strippingHTMLTags ?? ""
            let pubDate = entry.published ?? entry.updated ?? Date()
            let imageURL = extractImageURL(from: entry)
            let id = entry.id ?? link
            return NewsArticle(
                id: id,
                title: title,
                description: description,
                source: feedTitle,
                url: link,
                publishedAt: pubDate,
                imageURL: imageURL
            )
        } ?? []
    }

    private static func extractImageURL(from item: RSSFeedItem) -> String? {
        if let mediaURL = item.media?.mediaContents?.first?.attributes?.url {
            return mediaURL
        }
        if let thumbnailURL = item.media?.mediaThumbnails?.first?.attributes?.url {
            return thumbnailURL
        }
        if let enclosureURL = item.enclosure?.attributes?.url {
            return enclosureURL
        }
        return nil
    }

    private static func extractImageURL(from entry: AtomFeedEntry) -> String? {
        if let mediaURL = entry.media?.mediaContents?.first?.attributes?.url {
            return mediaURL
        }
        if let thumbnailURL = entry.media?.mediaThumbnails?.first?.attributes?.url {
            return thumbnailURL
        }
        return nil
    }
}

enum RSSSource: CaseIterable {
    case theRace
    case bbcSport
    case motorsport

    var url: String {
        switch self {
        case .theRace: return RSSFeedURL.theRace
        case .bbcSport: return RSSFeedURL.bbcSport
        case .motorsport: return RSSFeedURL.motorsport
        }
    }

    var displayName: String {
        switch self {
        case .theRace: return Strings.NewsService.sourceTheRace
        case .bbcSport: return Strings.NewsService.sourceBBC
        case .motorsport: return Strings.NewsService.sourceMotorsport
        }
    }

    var filterCategory: String? {
        switch self {
        case .theRace: return Strings.NewsService.categoryFormula1
        case .bbcSport, .motorsport: return nil
        }
    }
}

extension String {
    var strippingHTMLTags: String {
        replacingOccurrences(
            of: "<[^>]+>",
            with: "",
            options: .regularExpression
        )
        .trimmingCharacters(in: .whitespacesAndNewlines)
    }
}

extension [NewsArticle] {
    func deduplicated() -> [NewsArticle] {
        var seen = Set<String>()
        return filter { seen.insert($0.url).inserted }
    }
}
