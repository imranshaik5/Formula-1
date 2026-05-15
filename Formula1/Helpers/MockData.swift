import Foundation

enum MockData {
    static let teams: [Team] = [
        Team(id: "mclaren", name: "McLaren Mercedes", color: "F47600"),
        Team(id: "ferrari", name: "Ferrari", color: "ED1131"),
        Team(id: "redbull", name: "Red Bull Racing", color: "4781D7"),
        Team(id: "mercedes", name: "Mercedes", color: "00D7B6"),
        Team(id: "astonmartin", name: "Aston Martin", color: "229971"),
        Team(id: "alpine", name: "Alpine", color: "00A1E8"),
        Team(id: "racingbulls", name: "RB", color: "6C98FF"),
        Team(id: "williams", name: "Williams", color: "1868DB"),
        Team(id: "sauber", name: "Sauber", color: "01C00E"),
        Team(id: "haas", name: "Haas", color: "9C9FA2"),
        Team(id: "cadillac", name: "Cadillac", color: "1A1A2E"),
        Team(id: "audi", name: "Audi", color: "1A1A1A"),
    ]

    static let drivers: [Driver] = [
        Driver(id: "max_verstappen", name: "Max Verstappen", code: "VER", number: 1, nationality: "NL", team: teams[2], points: 295, position: 1, wins: 8),
        Driver(id: "lando_norris", name: "Lando Norris", code: "NOR", number: 4, nationality: "GB", team: teams[0], points: 225, position: 2, wins: 3),
        Driver(id: "charles_leclerc", name: "Charles Leclerc", code: "LEC", number: 16, nationality: "MC", team: teams[1], points: 195, position: 3, wins: 2),
        Driver(id: "oscar_piastri", name: "Oscar Piastri", code: "PIA", number: 81, nationality: "AU", team: teams[0], points: 179, position: 4, wins: 1),
        Driver(id: "carlos_sainz", name: "Carlos Sainz", code: "SAI", number: 55, nationality: "ES", team: teams[1], points: 162, position: 5, wins: 0),
        Driver(id: "lewis_hamilton", name: "Lewis Hamilton", code: "HAM", number: 44, nationality: "GB", team: teams[3], points: 148, position: 6, wins: 1),
        Driver(id: "sergio_perez", name: "Sergio Pérez", code: "PER", number: 11, nationality: "MX", team: teams[2], points: 131, position: 7, wins: 0),
        Driver(id: "george_russell", name: "George Russell", code: "RUS", number: 63, nationality: "GB", team: teams[3], points: 116, position: 8, wins: 1),
        Driver(id: "fernando_alonso", name: "Fernando Alonso", code: "ALO", number: 14, nationality: "ES", team: teams[4], points: 62, position: 9, wins: 0),
        Driver(id: "lance_stroll", name: "Lance Stroll", code: "STR", number: 18, nationality: "CA", team: teams[4], points: 24, position: 10, wins: 0),
        Driver(id: "pierre_gasly", name: "Pierre Gasly", code: "GAS", number: 10, nationality: "FR", team: teams[5], points: 36, position: 11, wins: 0),
        Driver(id: "esteban_ocon", name: "Esteban Ocon", code: "OCO", number: 31, nationality: "FR", team: teams[5], points: 19, position: 12, wins: 0),
        Driver(id: "yuki_tsunoda", name: "Yuki Tsunoda", code: "TSU", number: 22, nationality: "JP", team: teams[6], points: 22, position: 13, wins: 0),
        Driver(id: "daniel_ricciardo", name: "Daniel Ricciardo", code: "RIC", number: 3, nationality: "AU", team: teams[6], points: 11, position: 14, wins: 0),
        Driver(id: "alex_albon", name: "Alex Albon", code: "ALB", number: 23, nationality: "TH", team: teams[7], points: 8, position: 15, wins: 0),
        Driver(id: "logan_sargeant", name: "Logan Sargeant", code: "SAR", number: 2, nationality: "US", team: teams[7], points: 1, position: 16, wins: 0),
        Driver(id: "valtteri_bottas", name: "Valtteri Bottas", code: "BOT", number: 77, nationality: "FI", team: teams[8], points: 4, position: 17, wins: 0),
        Driver(id: "zhou_guanyu", name: "Zhou Guanyu", code: "ZHO", number: 24, nationality: "CN", team: teams[8], points: 0, position: 18, wins: 0),
        Driver(id: "kevin_magnussen", name: "Kevin Magnussen", code: "MAG", number: 20, nationality: "DK", team: teams[9], points: 5, position: 19, wins: 0),
        Driver(id: "nico_hulkenberg", name: "Nico Hülkenberg", code: "HUL", number: 27, nationality: "DE", team: teams[9], points: 7, position: 20, wins: 0),
        Driver(id: "placeholder", name: "TBD Driver", code: "TBD", number: 99, nationality: "US", team: teams[10], points: 0, position: 21, wins: 0),
    ]

    static let constructors: [Constructor] = [
        Constructor(id: "mclaren", name: "McLaren Mercedes", nationality: "GB"),
        Constructor(id: "ferrari", name: "Ferrari", nationality: "IT"),
        Constructor(id: "redbull", name: "Red Bull Racing", nationality: "AT"),
        Constructor(id: "mercedes", name: "Mercedes", nationality: "DE"),
        Constructor(id: "astonmartin", name: "Aston Martin", nationality: "GB"),
        Constructor(id: "alpine", name: "Alpine", nationality: "FR"),
        Constructor(id: "racingbulls", name: "RB", nationality: "IT"),
        Constructor(id: "williams", name: "Williams", nationality: "GB"),
        Constructor(id: "sauber", name: "Sauber", nationality: "CH"),
        Constructor(id: "haas", name: "Haas", nationality: "US"),
        Constructor(id: "cadillac", name: "Cadillac", nationality: "US"),
    ]

    static let constructorStandings: [ConstructorStanding] = [
        ConstructorStanding(id: "1", position: 1, constructor: constructors[0], points: 404, wins: 4),
        ConstructorStanding(id: "2", position: 2, constructor: constructors[2], points: 426, wins: 8),
        ConstructorStanding(id: "3", position: 3, constructor: constructors[1], points: 357, wins: 3),
        ConstructorStanding(id: "4", position: 4, constructor: constructors[3], points: 264, wins: 2),
        ConstructorStanding(id: "5", position: 5, constructor: constructors[4], points: 86, wins: 0),
        ConstructorStanding(id: "6", position: 6, constructor: constructors[5], points: 55, wins: 0),
        ConstructorStanding(id: "7", position: 7, constructor: constructors[6], points: 33, wins: 0),
        ConstructorStanding(id: "8", position: 8, constructor: constructors[7], points: 9, wins: 0),
        ConstructorStanding(id: "9", position: 9, constructor: constructors[9], points: 12, wins: 0),
        ConstructorStanding(id: "10", position: 10, constructor: constructors[8], points: 4, wins: 0),
        ConstructorStanding(id: "11", position: 11, constructor: constructors[10], points: 0, wins: 0),
    ]

    static let circuits: [(name: String, location: String, country: String)] = [
        ("Albert Park Circuit", "Melbourne", "Australia"),
        ("Shanghai International Circuit", "Shanghai", "China"),
        ("Miami International Autodrome", "Miami", "USA"),
        ("Autodromo Enzo e Dino Ferrari", "Imola", "Italy"),
        ("Circuit de Monaco", "Monte Carlo", "Monaco"),
        ("Circuit Gilles Villeneuve", "Montreal", "Canada"),
        ("Circuit de Barcelona-Catalunya", "Barcelona", "Spain"),
        ("Red Bull Ring", "Spielberg", "Austria"),
        ("Silverstone Circuit", "Silverstone", "Great Britain"),
        ("Hungaroring", "Budapest", "Hungary"),
        ("Circuit de Spa-Francorchamps", "Spa", "Belgium"),
        ("Circuit Zandvoort", "Zandvoort", "Netherlands"),
        ("Autodromo Nazionale di Monza", "Monza", "Italy"),
        ("Marina Bay Street Circuit", "Marina Bay", "Singapore"),
        ("Suzuka International Racing Course", "Suzuka", "Japan"),
        ("Losail International Circuit", "Lusail", "Qatar"),
        ("Circuit of the Americas", "Austin", "USA"),
        ("Autódromo Hermanos Rodríguez", "Mexico City", "Mexico"),
        ("Interlagos Circuit", "São Paulo", "Brazil"),
        ("Yas Marina Circuit", "Abu Dhabi", "UAE"),
    ]

    static let races: [Race] = {
        let allEntries: [RaceStatus.RaceResultEntry] = drivers.enumerated().map { i, d in
            RaceStatus.RaceResultEntry(driver: d, time: nil, points: max(26 - i * 2, 0), grid: i + 1, laps: 57)
        }

        let mockDetails = RaceStatus.RaceDetails(
            fastestLap: RaceStatus.FastestLap(driver: drivers[0], lap: 53, time: "1:23.456", speed: "234.567"),
            totalLaps: 57
        )

        func result(_ winner: Driver, _ podium: [Driver]) -> RaceStatus {
            .completed(RaceStatus.RaceResult(
                winner: winner, podium: podium, fullResults: allEntries, details: mockDetails
            ))
        }

        let calendar: [(name: String, index: Int, status: RaceStatus)] = [
            ("Australian Grand Prix", 0, result(drivers[0], [drivers[0], drivers[1], drivers[2]])),
            ("Chinese Grand Prix", 1, result(drivers[2], [drivers[2], drivers[0], drivers[3]])),
            ("Miami Grand Prix", 2, result(drivers[1], [drivers[1], drivers[3], drivers[4]])),
            ("Emilia Romagna Grand Prix", 3, result(drivers[0], [drivers[0], drivers[2], drivers[4]])),
            ("Monaco Grand Prix", 4, result(drivers[2], [drivers[2], drivers[1], drivers[5]])),
            ("Canadian Grand Prix", 5, result(drivers[0], [drivers[0], drivers[1], drivers[3]])),
            ("Spanish Grand Prix", 6, result(drivers[1], [drivers[1], drivers[0], drivers[2]])),
            ("Austrian Grand Prix", 7, result(drivers[3], [drivers[3], drivers[1], drivers[4]])),
            ("British Grand Prix", 8, result(drivers[5], [drivers[5], drivers[0], drivers[1]])),
            ("Hungarian Grand Prix", 9, result(drivers[3], [drivers[3], drivers[2], drivers[4]])),
            ("Belgian Grand Prix", 10, result(drivers[0], [drivers[0], drivers[2], drivers[3]])),
            ("Dutch Grand Prix", 11, result(drivers[1], [drivers[1], drivers[0], drivers[2]])),
            ("Italian Grand Prix", 12, result(drivers[2], [drivers[2], drivers[4], drivers[3]])),
            ("Singapore Grand Prix", 13, result(drivers[1], [drivers[1], drivers[2], drivers[0]])),
            ("Japanese Grand Prix", 14, result(drivers[0], [drivers[0], drivers[3], drivers[1]])),
            ("Qatar Grand Prix", 15, result(drivers[1], [drivers[1], drivers[0], drivers[4]])),
            ("United States Grand Prix", 16, result(drivers[2], [drivers[2], drivers[0], drivers[3]])),
            ("Mexico City Grand Prix", 17, result(drivers[4], [drivers[4], drivers[1], drivers[2]])),
            ("São Paulo Grand Prix", 18, .live),
            ("Abu Dhabi Grand Prix", 19, .upcoming),
        ]

        return calendar.enumerated().map { (index, item) in
            let circuit = circuits[item.index]
            let date = Date().addingTimeInterval(TimeInterval(index * 7 * 86400))
            return Race(
                id: "race_\(index + 1)",
                round: index + 1,
                name: item.name,
                circuit: Circuit(name: circuit.name, location: circuit.location, country: circuit.country),
                date: date,
                status: item.status
            )
        }
    }()

    static let newsArticles: [NewsArticle] = [
        NewsArticle(
            id: "1",
            title: "Verstappen Wins Thrilling Austrian Grand Prix",
            description: "Max Verstappen took a dominant victory at the Red Bull Ring, extending his championship lead over Lando Norris.",
            source: "The Race",
            url: "https://the-race.com",
            publishedAt: Date().addingTimeInterval(-3600),
            imageURL: nil
        ),
        NewsArticle(
            id: "2",
            title: "Ferrari Announce Technical Partnership for 2026",
            description: "Scuderia Ferrari has secured a major technical partnership deal ahead of the 2026 regulation changes.",
            source: "Autosport",
            url: "https://autosport.com",
            publishedAt: Date().addingTimeInterval(-7200),
            imageURL: nil
        ),
        NewsArticle(
            id: "3",
            title: "Hamilton Reflects on Challenging Season Start",
            description: "Lewis Hamilton opens up about Mercedes' struggles and his hopes for the remainder of the season.",
            source: "Formula 1",
            url: "https://formula1.com",
            publishedAt: Date().addingTimeInterval(-14400),
            imageURL: nil
        ),
        NewsArticle(
            id: "4",
            title: "Norris Signs Multi-Year Contract Extension",
            description: "Lando Norris has committed his long-term future to McLaren with a new multi-year contract.",
            source: "The Race",
            url: "https://the-race.com",
            publishedAt: Date().addingTimeInterval(-28800),
            imageURL: nil
        ),
    ]
}
