import Foundation

struct NewsArticle: Identifiable, Hashable {
    let id: String
    let title: String
    let description: String
    let source: String
    let url: String
    let publishedAt: Date
    let imageURL: String?

    var relativeDate: String {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .abbreviated
        return formatter.localizedString(for: publishedAt, relativeTo: Date())
    }
}
