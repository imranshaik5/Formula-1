import Foundation

@MainActor
final class DriverDetailViewModel: ObservableObject {
    @Published private(set) var driver: Driver
    @Published private(set) var careerResults: [RaceStatus.RaceResultEntry] = []
    @Published private(set) var videoResults: [String: [VideoItem]] = [:]
    @Published var loadState: LoadState<Void> = .idle

    private let driverService: DriverServiceProtocol
    private let youtubeService: YouTubeService

    let videoQueries: [(title: String, query: String)] = []

    init(driver: Driver, driverService: DriverServiceProtocol = DriverService(), youtubeService: YouTubeService = YouTubeService()) {
        self.driver = driver
        self.driverService = driverService
        self.youtubeService = youtubeService
    }

    var bestResults: [RaceStatus.RaceResultEntry] {
        careerResults
            .filter { $0.driver.position <= 3 }
            .sorted { $0.driver.position < $1.driver.position }
            .prefix(5).map { $0 }
    }

    var videoCategories: [(key: String, title: String, query: String)] {
        [
            ("highlights", "Career Highlights", "\(driver.name) F1 career highlights"),
            ("bestRaces", "Best Races", "\(driver.name) best races"),
            ("onboard", "Onboard Magic", "\(driver.name) onboard best moments"),
            ("interviews", "Interviews", "\(driver.name) F1 interview"),
            ("review", "Season Review", "\(driver.name) 2026 review"),
        ]
    }

    func loadDriverDetails() async {
        loadState = .loading
        do {
            async let updated = driverService.fetchDriver(by: driver.id)
            async let results = driverService.fetchDriverResults(driverId: driver.id)
            if let driver = try await updated {
                self.driver = driver
            }
            careerResults = try await results
            await loadVideoThumbnails()
            loadState = .loaded(())
        } catch {
            loadState = .error(error)
        }
    }

    private func loadVideoThumbnails() async {
        for cat in videoCategories {
            let items = await youtubeService.search(cat.query, maxResults: 1)
            videoResults[cat.key] = items
        }
    }

    func thumbnailURL(for key: String) -> URL? {
        videoResults[key]?.first?.thumbnailURL
    }

    func videoURL(for key: String) -> URL? {
        videoResults[key]?.first?.videoURL
    }
}
