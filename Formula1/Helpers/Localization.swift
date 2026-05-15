import Foundation

enum Strings {
    enum RaceList {
        static let title = NSLocalizedString("race_list.title", value: "Race Calendar", comment: "Race list navigation title")
        static let loading = NSLocalizedString("race_list.loading", value: "Loading races...", comment: "Loading indicator text")
        static let errorTitle = NSLocalizedString("race_list.error_title", value: "Error Loading Races", comment: "Error state title")
        static let upNext = NSLocalizedString("race_list.up_next", value: "UP NEXT", comment: "Hero card section heading")
        static let seasonCalendar = NSLocalizedString("race_list.season_calendar", value: "Season Calendar", comment: "Section header for all races")
        static let completed = NSLocalizedString("race_list.completed", value: "Completed", comment: "Race status badge")
        static let live = NSLocalizedString("race_list.live", value: "LIVE", comment: "Race status badge for live races")
        static let upcoming = NSLocalizedString("race_list.upcoming", value: "Upcoming", comment: "Race status badge for upcoming races")
    }

    enum RaceDetail {
        static let title = NSLocalizedString("race_detail.title", value: "Race Details", comment: "Race detail navigation title")
        static let raceStartsIn = NSLocalizedString("race_detail.race_starts_in", value: "Race starts in", comment: "Countdown title for upcoming race")
        static let raceIsLive = NSLocalizedString("race_detail.race_is_live", value: "Race is Live", comment: "Live race status")
        static let raceCompleted = NSLocalizedString("race_detail.race_completed", value: "Race Completed", comment: "Completed race status")
        static func round(_ number: Int) -> String {
            String(format: NSLocalizedString("race_detail.round", value: "Round %d", comment: "Race round number"), number)
        }
        static func winner(_ name: String) -> String {
            String(format: NSLocalizedString("race_detail.winner", value: "Winner: %@", comment: "Winner label"), name)
        }
        static let podium = NSLocalizedString("race_detail.podium", value: "Podium", comment: "Podium section title")
        static let circuitInfo = NSLocalizedString("race_detail.circuit_info", value: "Circuit Information", comment: "Circuit details section title")
        static let circuitLabel = NSLocalizedString("race_detail.circuit_label", value: "Circuit", comment: "Circuit name label")
        static let locationLabel = NSLocalizedString("race_detail.location_label", value: "Location", comment: "Location label")
        static let countryLabel = NSLocalizedString("race_detail.country_label", value: "Country", comment: "Country label")
    }

    enum DriverList {
        static let title = NSLocalizedString("driver_list.title", value: "Driver Standings", comment: "Driver list navigation title")
        static let loading = NSLocalizedString("driver_list.loading", value: "Loading drivers...", comment: "Loading indicator text")
        static let errorTitle = NSLocalizedString("driver_list.error_title", value: "Error Loading Drivers", comment: "Error state title")
        static func position(_ number: Int) -> String {
            String(format: NSLocalizedString("driver_list.position", value: "P%d", comment: "Driver position prefix"), number)
        }
    }

    enum DriverDetail {
        static func position(_ number: Int) -> String {
            String(format: NSLocalizedString("driver_detail.position", value: "P%d in standings", comment: "Driver position in standings"), number)
        }
        static let seasonStats = NSLocalizedString("driver_detail.season_stats", value: "Season Statistics", comment: "Statistics section title")
        static let positionLabel = NSLocalizedString("driver_detail.position_label", value: "Position", comment: "Stat item label")
        static let pointsLabel = NSLocalizedString("driver_detail.points_label", value: "Points", comment: "Stat item label")
        static let numberLabel = NSLocalizedString("driver_detail.number_label", value: "Number", comment: "Stat item label")
        static let pointsProgress = NSLocalizedString("driver_detail.points_progress", value: "Points Progress", comment: "Progress bar section title")
        static let teamInfo = NSLocalizedString("driver_detail.team_info", value: "Team Information", comment: "Team details section title")
        static func driverNumber(_ number: Int) -> String {
            String(format: NSLocalizedString("driver_detail.driver_number", value: "Driver #%d", comment: "Driver number subtitle"), number)
        }
    }

    enum ConstructorList {
        static let title = NSLocalizedString("constructor_list.title", value: "Constructors", comment: "Constructor list navigation title")
        static let loading = NSLocalizedString("constructor_list.loading", value: "Loading standings...", comment: "Loading indicator text")
        static let errorTitle = NSLocalizedString("constructor_list.error_title", value: "Error Loading Standings", comment: "Error state title")
        static let points = NSLocalizedString("constructor_list.points", value: "points", comment: "Points label suffix")
        static func wins(_ count: Int) -> String {
            let format = NSLocalizedString("constructor_list.wins", value: "%d wins", comment: "Win count")
            return String(format: format, count)
        }
        static func win(_ count: Int) -> String {
            let format = NSLocalizedString("constructor_list.win", value: "%d win", comment: "Win count singular")
            return String(format: format, count)
        }
    }

    enum ConstructorDetail {
        static func position(_ number: Int) -> String {
            String(format: NSLocalizedString("constructor_detail.position", value: "P%d in standings", comment: "Constructor position in standings"), number)
        }
        static let seasonStats = NSLocalizedString("constructor_detail.season_stats", value: "Season Statistics", comment: "Statistics section title")
        static let positionLabel = NSLocalizedString("constructor_detail.position_label", value: "Position", comment: "Stat item label")
        static let pointsLabel = NSLocalizedString("constructor_detail.points_label", value: "Points", comment: "Stat item label")
        static let winsLabel = NSLocalizedString("constructor_detail.wins_label", value: "Wins", comment: "Stat item label")
        static let pointsProgress = NSLocalizedString("constructor_detail.points_progress", value: "Points Progress", comment: "Progress bar section title")
    }

    enum NewsList {
        static let title = NSLocalizedString("news_list.title", value: "News", comment: "News list navigation title")
        static let loading = NSLocalizedString("news_list.loading", value: "Loading news...", comment: "Loading indicator text")
        static let emptyTitle = NSLocalizedString("news_list.empty_title", value: "No News", comment: "Empty state title")
        static let emptyDescription = NSLocalizedString("news_list.empty_description", value: "Check back later for F1 news updates.", comment: "Empty state description")
    }

    enum Splash {
        static let formula1 = NSLocalizedString("splash.formula1", value: "FORMULA 1", comment: "Brand wordmark subtitle")
        static let startEngines = NSLocalizedString("splash.start_engines", value: "START YOUR ENGINES", comment: "Primary CTA tagline")
        static let getReady = NSLocalizedString("splash.get_ready", value: "GET READY FOR RACE DAY", comment: "Secondary tagline")
    }

    enum Countdown {
        static let raceWeekendLive = NSLocalizedString("countdown.race_weekend_live", value: "Race Weekend Live!", comment: "Label when race is live")
        static let days = NSLocalizedString("countdown.days", value: "days", comment: "Days unit")
        static let hrs = NSLocalizedString("countdown.hrs", value: "hrs", comment: "Hours unit")
        static let min = NSLocalizedString("countdown.min", value: "min", comment: "Minutes unit")
        static let sec = NSLocalizedString("countdown.sec", value: "sec", comment: "Seconds unit")
    }

    enum Podium {
        static func position(_ number: Int) -> String {
            String(format: NSLocalizedString("podium.position", value: "#%d", comment: "Podium position prefix"), number)
        }
    }

    enum Common {
        static let bullet = NSLocalizedString("common.bullet", value: "\u{2022}", comment: "Bullet point separator")
    }
}
