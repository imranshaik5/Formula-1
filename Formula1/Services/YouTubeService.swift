import Foundation
import Alamofire

final class YouTubeService {
    private let session: Session

    init(session: Session = .default) {
        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = 10
        config.timeoutIntervalForResource = 15
        self.session = Session(configuration: config)
    }

    func search(_ query: String, maxResults: Int = 6) async -> [VideoItem] {
        let encoded = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? query
        let url = "https://www.youtube.com/results?search_query=\(encoded)"

        let headers: HTTPHeaders = [
            "User-Agent": "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36",
            "Accept-Language": "en-US,en;q=0.9",
        ]

        do {
            let data = try await session.request(url, headers: headers).serializingData().value
            guard let html = String(data: data, encoding: .utf8) else { return [] }

            let videos = parseYouTubeInitialData(from: html)

            return videos.prefix(maxResults).map { (vid, title) in
                VideoItem(
                    id: vid,
                    title: title,
                    thumbnailURL: URL(string: "https://img.youtube.com/vi/\(vid)/mqdefault.jpg")!,
                    videoURL: URL(string: "https://www.youtube.com/watch?v=\(vid)")!,
                    duration: ""
                )
            }
        } catch {
            return []
        }
    }

    private func parseYouTubeInitialData(from html: String) -> [(String, String)] {
        guard let start = html.range(of: "ytInitialData"),
              let equals = html[start.upperBound...].range(of: "="),
              let jsonStart = html[equals.upperBound...].range(of: "{") else { return [] }

        var depth = 0
        var jsonEnd = jsonStart.lowerBound
        for i in html[jsonStart.lowerBound...].indices {
            if html[i] == "{" { depth += 1 }
            if html[i] == "}" { depth -= 1 }
            if depth == 0 { jsonEnd = i; break }
        }

        let raw = html[jsonStart.lowerBound...jsonEnd]
        guard let data = raw.data(using: .utf8),
              let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any] else { return [] }

        var results: [(String, String)] = []

        guard let contents = json["contents"] as? [String: Any],
              let twoColumn = contents["twoColumnSearchResultsRenderer"] as? [String: Any],
              let primary = twoColumn["primaryContents"] as? [String: Any],
              let sectionList = primary["sectionListRenderer"] as? [String: Any],
              let sections = sectionList["contents"] as? [[String: Any]] else { return results }

        for section in sections {
            guard let itemSection = section["itemSectionRenderer"] as? [String: Any],
                  let items = itemSection["contents"] as? [[String: Any]] else { continue }

            for item in items {
                guard let video = item["videoRenderer"] as? [String: Any],
                      let videoId = video["videoId"] as? String else { continue }

                let title = extractVideoTitle(from: video)
                results.append((videoId, title))
            }
        }

        return results
    }

    private func extractVideoTitle(from video: [String: Any]) -> String {
        guard let title = video["title"] as? [String: Any] else { return "" }
        if let runs = title["runs"] as? [[String: Any]] {
            return runs.compactMap { $0["text"] as? String }.joined()
        }
        return title["simpleText"] as? String ?? ""
    }
}
