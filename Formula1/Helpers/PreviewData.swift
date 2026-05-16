import Foundation

enum PreviewData {
    static let circuit = Circuit(name: "Silverstone Circuit", location: "Silverstone", country: "Great Britain")

    static let team = Team(id: "red_bull", name: "Red Bull Racing", color: "#4781D7")

    static let driver = Driver(
        id: "max_verstappen", name: "Max Verstappen", code: "VER",
        number: 1, nationality: "Dutch", team: team,
        points: 285, position: 1, wins: 8
    )

    static let driver2 = Driver(
        id: "sergio_perez", name: "Sergio Pérez", code: "PER",
        number: 11, nationality: "Mexican", team: team,
        points: 180, position: 2, wins: 2
    )

    static let ferrariTeam = Team(id: "ferrari", name: "Ferrari", color: "#ED1131")

    static let driver3 = Driver(
        id: "charles_leclerc", name: "Charles Leclerc", code: "LEC",
        number: 16, nationality: "Monegasque", team: ferrariTeam,
        points: 165, position: 3, wins: 1
    )

    static let constructor = Constructor(id: "red_bull", name: "Red Bull Racing", nationality: "Austrian")

    static let constructorStanding = ConstructorStanding(
        id: "red_bull", position: 1,
        constructor: constructor, points: 465, wins: 10
    )

    static let race = Race(
        id: "2026-1", round: 1, name: "Australian Grand Prix",
        circuit: circuit, date: Date().addingTimeInterval(86400 * 7),
        status: .upcoming
    )

    static let completedRace = Race(
        id: "2026-5", round: 5, name: "Monaco Grand Prix",
        circuit: Circuit(name: "Circuit de Monaco", location: "Monte Carlo", country: "Monaco"),
        date: Date().addingTimeInterval(-86400 * 2),
        status: .completed(RaceStatus.RaceResult(
            winner: driver,
            podium: [driver, driver2, driver3],
            fullResults: [
                RaceStatus.RaceResultEntry(driver: driver, time: "1:32:45.123", points: 25, grid: 1, laps: 78),
                RaceStatus.RaceResultEntry(driver: driver2, time: "+8.542", points: 18, grid: 3, laps: 78),
                RaceStatus.RaceResultEntry(driver: driver3, time: "+15.234", points: 15, grid: 2, laps: 78),
            ],
            details: RaceStatus.RaceDetails(
                fastestLap: RaceStatus.FastestLap(driver: driver, lap: 56, time: "1:12.456", speed: "235.4"),
                totalLaps: 78
            )
        ))
    )

    static let articles: [NewsArticle] = [
        NewsArticle(
            id: "1", title: "Hamilton Shocks F1 with Ferrari Move",
            description: "In a stunning announcement, Lewis Hamilton will join Ferrari for the 2025 season.",
            source: "F1 Official", url: "https://example.com", publishedAt: Date(),
            imageURL: nil
        ),
        NewsArticle(
            id: "2", title: "Red Bull Dominates Season Opener",
            description: "Max Verstappen takes commanding victory in Bahrain.",
            source: "Motorsport", url: "https://example.com", publishedAt: Date().addingTimeInterval(-86400),
            imageURL: nil
        ),
    ]
}
