import WidgetKit
import SwiftUI

struct WidgetEntry: TimelineEntry {
    let date: Date
    let data: WidgetRaceData
    let isPlaceholder: Bool

    static let preview = WidgetEntry(
        date: Date(),
        data: WidgetRaceData(
            nextRaceName: "Austrian Grand Prix",
            nextRaceDate: Date().addingTimeInterval(86400 * 2),
            nextRaceRound: 8,
            topDriverName: "Andrea Kimi Antonelli",
            topDriverTeam: "Mercedes",
            topConstructorName: "Mercedes",
            topConstructorPoints: 262
        ),
        isPlaceholder: false
    )
}

struct Provider: TimelineProvider {
    private let service = WidgetDataService()

    func placeholder(in context: Context) -> WidgetEntry {
        WidgetEntry.preview
    }

    func getSnapshot(in context: Context, completion: @escaping (WidgetEntry) -> Void) {
        if context.isPreview {
            completion(WidgetEntry.preview)
            return
        }
        Task {
            let data = await service.fetchWidgetData()
            let entry = WidgetEntry(date: Date(), data: data, isPlaceholder: false)
            DispatchQueue.main.async {
                completion(entry)
            }
        }
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<WidgetEntry>) -> Void) {
        Task {
            let data = await service.fetchWidgetData()
            let entry = WidgetEntry(date: Date(), data: data, isPlaceholder: false)
            let nextUpdate = Calendar.current.date(byAdding: .minute, value: 30, to: Date()) ?? Date().addingTimeInterval(1800)
            let timeline = Timeline(entries: [entry], policy: .after(nextUpdate))
            DispatchQueue.main.async {
                completion(timeline)
            }
        }
    }
}

@main
struct Formula1Widget: Widget {
    let kind: String = "Formula1Widget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            LargeWidgetView(entry: entry)
        }
        .configurationDisplayName("Formula 1")
        .description("Next race, driver standings, and constructor standings.")
        .supportedFamilies([.systemLarge])
    }
}
