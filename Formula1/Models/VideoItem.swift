import Foundation

struct VideoItem: Identifiable {
    let id: String
    let title: String
    let thumbnailURL: URL
    let videoURL: URL
    let duration: String
}
