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
        static let sectionPodium = NSLocalizedString("race_detail.section_podium", value: "PODIUM", comment: "Section divider")
        static let sectionClassification = NSLocalizedString("race_detail.section_classification", value: "CLASSIFICATION", comment: "Section divider")
        static let sectionFastestLap = NSLocalizedString("race_detail.section_fastest_lap", value: "FASTEST LAP", comment: "Section divider")
        static let sectionRaceDetails = NSLocalizedString("race_detail.section_race_details", value: "RACE DETAILS", comment: "Section divider")
        static let sectionGrandPrix = NSLocalizedString("race_detail.section_grand_prix", value: "GRAND PRIX", comment: "Section divider")
        static let sectionQualifying = NSLocalizedString("race_detail.section_qualifying", value: "QUALIFYING", comment: "Section divider")
        static let sectionStartingGrid = NSLocalizedString("race_detail.section_starting_grid", value: "STARTING GRID", comment: "Section divider")
        static let sectionFastestLaps = NSLocalizedString("race_detail.section_fastest_laps", value: "FASTEST LAPS", comment: "Section divider")
        static let sectionPitStops = NSLocalizedString("race_detail.section_pit_stops", value: "PIT STOPS", comment: "Section divider")
        static let sectionDriverOfTheDay = NSLocalizedString("race_detail.section_driver_of_the_day", value: "DRIVER OF THE DAY", comment: "Section divider")
        static let sectionGridVsFinish = NSLocalizedString("race_detail.section_grid_vs_finish", value: "GRID vs FINISH", comment: "Section divider")
        static let sectionRaceMedia = NSLocalizedString("race_detail.section_race_media", value: "RACE MEDIA", comment: "Section divider")
        static let winnerLabel = NSLocalizedString("race_detail.winner_label", value: "WINNER", comment: "Winner card label")
        static func lapOf(_ lap: Int, _ total: Int) -> String {
            String(format: NSLocalizedString("race_detail.lap_of", value: "Lap %d of %d", comment: "Fastest lap detail"), lap, total)
        }
        static let fastestLapLabel = NSLocalizedString("race_detail.fastest_lap_label", value: "Fastest Lap", comment: "Detail row label")
        static let mediaHighlights = NSLocalizedString("race_detail.media_highlights", value: "Highlights", comment: "Media category")
        static let mediaTopRated = NSLocalizedString("race_detail.media_top_rated", value: "Top Rated", comment: "Media category")
        static let mediaViral = NSLocalizedString("race_detail.media_viral", value: "Viral", comment: "Media category")
        static let mediaTitles: [String] = [
            NSLocalizedString("race_detail.media_title_highlights", value: "Race Highlights", comment: "Media card title"),
            NSLocalizedString("race_detail.media_title_overtakes", value: "Best Overtakes", comment: "Media card title"),
            NSLocalizedString("race_detail.media_title_first_lap", value: "First Lap Chaos", comment: "Media card title"),
            NSLocalizedString("race_detail.media_title_team_radio", value: "Team Radio Moments", comment: "Media card title"),
            NSLocalizedString("race_detail.media_title_pit_stop", value: "Pit Stop Battle", comment: "Media card title"),
        ]
        static let gridDeltaGain = NSLocalizedString("race_detail.grid_delta_gain", value: "+%d", comment: "Grid position gain")
        static let gridDeltaLoss = NSLocalizedString("race_detail.grid_delta_loss", value: "%d", comment: "Grid position loss (negative number)")
        static let gridDeltaSame = NSLocalizedString("race_detail.grid_delta_same", value: "–", comment: "No grid position change")
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
        static let seasonResults = NSLocalizedString("driver_detail.season_results", value: "2026 SEASON RESULTS", comment: "Section title")
        static let bestMoments = NSLocalizedString("driver_detail.best_moments", value: "BEST MOMENTS", comment: "Section title")
        static let bestMomentsVideos = NSLocalizedString("driver_detail.best_moments_videos", value: "BEST MOMENTS VIDEOS", comment: "Section title")
        static func points(_ pts: Int) -> String {
            String(format: NSLocalizedString("driver_detail.points_suffix", value: "+%d pts", comment: "Points with plus sign"), pts)
        }
        static func round(_ number: Int) -> String {
            String(format: NSLocalizedString("driver_detail.round", value: "R%d", comment: "Round number prefix"), number)
        }
        static func positionP(_ pos: Int) -> String {
            String(format: NSLocalizedString("driver_detail.position_p", value: "P%d", comment: "Position with P prefix"), pos)
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
        static let driverContributions = NSLocalizedString("constructor_detail.driver_contributions", value: "Driver Contributions", comment: "Section title")
        static let noRaceData = NSLocalizedString("constructor_detail.no_race_data", value: "No race data available", comment: "Empty state text")
        static let seasonResults = NSLocalizedString("constructor_detail.season_results", value: "Season Statistics", comment: "Section title")
    }

    enum NewsService {
        static let userAgent = NSLocalizedString("news_service.user_agent", value: "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36", comment: "HTTP User-Agent header")
        static let sourceTheRace = NSLocalizedString("news_service.source_the_race", value: "The Race", comment: "RSS source display name")
        static let sourceBBC = NSLocalizedString("news_service.source_bbc", value: "BBC Sport", comment: "RSS source display name")
        static let sourceMotorsport = NSLocalizedString("news_service.source_motorsport", value: "Motorsport", comment: "RSS source display name")
        static let categoryFormula1 = NSLocalizedString("news_service.category_f1", value: "Formula 1", comment: "RSS category filter")
        static let errorInvalidResponse = NSLocalizedString("news_service.error_invalid_response", value: "Invalid response from news source", comment: "Error description")
        static let errorAllSourcesFailed = NSLocalizedString("news_service.error_all_sources_failed", value: "Unable to fetch news from any source", comment: "Error description")
        static let errorCancelled = NSLocalizedString("news_service.error_cancelled", value: "News fetch was cancelled", comment: "Error description")
    }

    enum NewsList {
        static let title = NSLocalizedString("news_list.title", value: "News", comment: "News list navigation title")
        static let loading = NSLocalizedString("news_list.loading", value: "Loading news...", comment: "Loading indicator text")
        static let emptyTitle = NSLocalizedString("news_list.empty_title", value: "No News", comment: "Empty state title")
        static let emptyDescription = NSLocalizedString("news_list.empty_description", value: "Check back later for F1 news updates.", comment: "Empty state description")
        static let errorTitle = NSLocalizedString("news_list.error_title", value: "Failed to Load News", comment: "Error state title")
        static let errorDescription = NSLocalizedString("news_list.error_description", value: "Please check your internet connection and try again.", comment: "Error state description")
        static let retry = NSLocalizedString("news_list.retry", value: "Retry", comment: "Retry button label")
        static let lastUpdated = NSLocalizedString("news_list.last_updated", value: "Updated just now", comment: "Last updated time label")
        static let openArticle = NSLocalizedString("news_list.open_article", value: "Open Article", comment: "Article card footer link")
    }

    enum Trivia {
        static let title = NSLocalizedString("trivia.title", value: "Trivia", comment: "Trivia navigation title")
        static let startTitle = NSLocalizedString("trivia.start_title", value: "F1 Trivia Challenge", comment: "Start screen title")
        static let startDescription = NSLocalizedString("trivia.start_description", value: "Test your Formula 1 knowledge with 10 questions covering history, drivers, circuits, and records.", comment: "Start screen description")
        static let startButton = NSLocalizedString("trivia.start_button", value: "Start Quiz", comment: "Start button")
        static func questionLabel(_ current: Int, _ total: Int) -> String {
            String(format: NSLocalizedString("trivia.question_label", value: "Question %d of %d", comment: "Question progress"), current, total)
        }
        static let nextQuestion = NSLocalizedString("trivia.next_question", value: "Next Question", comment: "Next question button")
        static let seeResults = NSLocalizedString("trivia.see_results", value: "See Results", comment: "See results button")
        static let resultTitle = NSLocalizedString("trivia.result_title", value: "Quiz Complete!", comment: "Results title")
        static let playAgain = NSLocalizedString("trivia.play_again", value: "Play Again", comment: "Play again button")
        static let goHome = NSLocalizedString("trivia.go_home", value: "Back to Start", comment: "Go home button")
        static let messagePerfect = NSLocalizedString("trivia.message_perfect", value: "Perfect score! You're an F1 expert!", comment: "Perfect score message")
        static let messageGreat = NSLocalizedString("trivia.message_great", value: "Great job! You really know your F1!", comment: "Great score message")
        static let messageGood = NSLocalizedString("trivia.message_good", value: "Not bad! Brush up on your F1 knowledge.", comment: "Good score message")
        static let messageTryAgain = NSLocalizedString("trivia.message_try_again", value: "Time to study up! Try again!", comment: "Low score message")
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

    enum LiveTiming {
        static let connecting = NSLocalizedString("livetiming.connecting", value: "Connecting to live timing...", comment: "Connecting state")
        static let pos = NSLocalizedString("livetiming.pos", value: "POS", comment: "Table header position")
        static let driver = NSLocalizedString("livetiming.driver", value: "DRIVER", comment: "Table header driver")
        static let gap = NSLocalizedString("livetiming.gap", value: "GAP", comment: "Table header gap to front")
        static let interval = NSLocalizedString("livetiming.interval", value: "INT", comment: "Table header interval")
        static let lap = NSLocalizedString("livetiming.lap", value: "LAP", comment: "Table header lap time")
        static let fastestLap = NSLocalizedString("livetiming.fastest_lap", value: "FASTEST LAP", comment: "Fastest lap indicator")
        static let greenFlag = NSLocalizedString("livetiming.green_flag", value: "GREEN", comment: "Green flag status")
        static let yellowFlag = NSLocalizedString("livetiming.yellow_flag", value: "YELLOW", comment: "Yellow flag status")
        static let safetyCar = NSLocalizedString("livetiming.safety_car", value: "SAFETY CAR", comment: "Safety car status")
        static let redFlag = NSLocalizedString("livetiming.red_flag", value: "RED FLAG", comment: "Red flag status")
        static let vsc = NSLocalizedString("livetiming.vsc", value: "VSC", comment: "Virtual safety car status")
        static let lapPrefix = NSLocalizedString("livetiming.lap_prefix", value: "Lap", comment: "Lap prefix in header")
        static let airTemp = NSLocalizedString("livetiming.air_temp", value: "Air", comment: "Air temperature")
        static let trackTemp = NSLocalizedString("livetiming.track_temp", value: "Track", comment: "Track temperature")
    }

    enum Podium {
        static func position(_ number: Int) -> String {
            String(format: NSLocalizedString("podium.position", value: "#%d", comment: "Podium position prefix"), number)
        }
    }

    enum Common {
        static let bullet = NSLocalizedString("common.bullet", value: "\u{2022}", comment: "Bullet point separator")
        static let pts = NSLocalizedString("common.pts", value: "PTS", comment: "Points abbreviation")
        static let driver = NSLocalizedString("common.driver", value: "DRIVER", comment: "Table header for driver name")
        static let pos = NSLocalizedString("common.pos", value: "POS", comment: "Table header for position")
        static let time = NSLocalizedString("common.time", value: "TIME", comment: "Table header for time")
        static let start = NSLocalizedString("common.start", value: "START", comment: "Table header for start position")
        static let finish = NSLocalizedString("common.finish", value: "FINISH", comment: "Table header for finish position")
        static let points = NSLocalizedString("common.points", value: "Points", comment: "Stat label for points")
        static let wins = NSLocalizedString("common.wins", value: "Wins", comment: "Stat label for wins")
        static let position = NSLocalizedString("common.position", value: "Position", comment: "Stat label for position")
        static let seasonStats = NSLocalizedString("common.season_stats", value: "Season Statistics", comment: "Section title for season statistics")
        static let pointsProgress = NSLocalizedString("common.points_progress", value: "Points Progress", comment: "Section title for points progress bar")
        static let raceResults = NSLocalizedString("common.race_results", value: "Race Results", comment: "Section title for race results")
        static let noDataAvailable = NSLocalizedString("common.no_data_available", value: "No data available", comment: "Empty state text")
        static let races = NSLocalizedString("common.races", value: "Races", comment: "Stat label")
        static let circuits = NSLocalizedString("common.circuits", value: "Circuits", comment: "Section title")
        static func moreCount(_ count: Int) -> String {
            String(format: NSLocalizedString("common.more_count", value: "+ %d more", comment: "Additional items count"), count)
        }
    }

    enum SideMenu {
        static let f1Fallback = NSLocalizedString("sidemenu.f1_fallback", value: "F1", comment: "Fallback text when logo fails to load")
        static let historicalData = NSLocalizedString("sidemenu.historical_data", value: "F1DB Historical Data", comment: "Footer label")
        static let version = NSLocalizedString("sidemenu.version", value: "v2026.4.2", comment: "App version in footer")
        static let raceCalendar = NSLocalizedString("sidemenu.race_calendar", value: "Race Calendar", comment: "Tab title")
        static let drivers = NSLocalizedString("sidemenu.drivers", value: "Drivers", comment: "Tab title")
        static let constructors = NSLocalizedString("sidemenu.constructors", value: "Constructors", comment: "Tab title")
        static let news = NSLocalizedString("sidemenu.news", value: "News", comment: "Tab title")
        static let tickets = NSLocalizedString("sidemenu.tickets", value: "F1 Tickets", comment: "Tab title")
        static let store = NSLocalizedString("sidemenu.store", value: "F1 Store", comment: "Tab title")
        static let trivia = NSLocalizedString("sidemenu.trivia", value: "Trivia", comment: "Tab title")
        static let debug = NSLocalizedString("sidemenu.debug", value: "Debug", comment: "Tab title")
    }

    enum Debug {
        static let title = NSLocalizedString("debug.title", value: "Debug Settings", comment: "Navigation title")
        static let header = NSLocalizedString("debug.header", value: "Developer Settings", comment: "Section header")
        static let subtitle = NSLocalizedString("debug.subtitle", value: "Configure mock data and testing options", comment: "Section subtitle")
        static let mockSection = NSLocalizedString("debug.mock_section", value: "Mock Data", comment: "Section label")
        static let mockMode = NSLocalizedString("debug.mock_mode", value: "Mock Mode", comment: "Toggle label")
        static let mockModeDetail = NSLocalizedString("debug.mock_mode_detail", value: "Use local mock data instead of live server", comment: "Toggle detail")
        static let forceLive = NSLocalizedString("debug.force_live", value: "Force Live", comment: "Toggle label")
        static let forceLiveDetail = NSLocalizedString("debug.force_live_detail", value: "Show any race as live for testing", comment: "Toggle detail")
        static let restartNote = NSLocalizedString("debug.restart_note", value: "Reopen the race detail view for changes to take effect", comment: "Restart note")
        static let serverSection = NSLocalizedString("debug.server_section", value: "Server", comment: "Section label")
        static let mockServerStatus = NSLocalizedString("debug.mock_server_status", value: "Mock data active (local)", comment: "Server status")
        static let serverStatusIdle = NSLocalizedString("debug.server_status_idle", value: "Not connected to mock server", comment: "Server status")
        static let serverNote = NSLocalizedString("debug.server_note", value: "Mock mode generates data locally in the app. No Python server needed.", comment: "Server note")
    }

    enum ConstructorStandings {
        static let season2026 = NSLocalizedString("constructor_standings.season_2026", value: "2026 SEASON", comment: "Season year header")
        static let championship = NSLocalizedString("constructor_standings.championship", value: "Constructors Championship", comment: "Section title")
        static let points = NSLocalizedString("constructor_standings.points", value: "points", comment: "Points suffix")
    }

    enum F1DB {
        static let allTimeStats = NSLocalizedString("f1db.all_time_stats", value: "All-Time Stats", comment: "Section title")
        static let allTimeCareerStats = NSLocalizedString("f1db.all_time_career_stats", value: "All-Time Career Stats", comment: "Section title")
        static let history = NSLocalizedString("f1db.history", value: "History", comment: "Section title")
        static let family = NSLocalizedString("f1db.family", value: "Family", comment: "Section title")
        static let fastestLaps = NSLocalizedString("f1db.fastest_laps", value: "Fastest Laps", comment: "Stat label")
        static let noData = NSLocalizedString("f1db.no_data", value: "No data available", comment: "Empty state")
        static let present = NSLocalizedString("f1db.present", value: "Present", comment: "End year in timeline")
        static let familyChild = NSLocalizedString("f1db.family_child", value: "Child", comment: "Family relationship")
        static let familyParent = NSLocalizedString("f1db.family_parent", value: "Parent", comment: "Family relationship")
        static let familySibling = NSLocalizedString("f1db.family_sibling", value: "Sibling", comment: "Family relationship")
        static let familyNieceNephew = NSLocalizedString("f1db.family_niece_nephew", value: "Niece/Nephew", comment: "Family relationship")
        static let familyCousin = NSLocalizedString("f1db.family_cousin", value: "Cousin", comment: "Family relationship")
        static let familySpouse = NSLocalizedString("f1db.family_spouse", value: "Spouse", comment: "Family relationship")
        static let entries = NSLocalizedString("f1db.entries", value: "Entries", comment: "Stat label")
        static let starts = NSLocalizedString("f1db.starts", value: "Starts", comment: "Stat label")
        static let wins = NSLocalizedString("f1db.wins", value: "Wins", comment: "Stat label")
        static let podiums = NSLocalizedString("f1db.podiums", value: "Podiums", comment: "Stat label")
        static let poles = NSLocalizedString("f1db.poles", value: "Poles", comment: "Stat label")
        static let dotd = NSLocalizedString("f1db.dotd", value: "DOTD", comment: "Driver of the Day abbreviation")
        static let grandSlams = NSLocalizedString("f1db.grand_slams", value: "Grand Slams", comment: "Stat label")
        static let championships = NSLocalizedString("f1db.championships", value: "Championships", comment: "Stat label")
        static let points = NSLocalizedString("f1db.points", value: "Points", comment: "Stat label")
        static let lapsLed = NSLocalizedString("f1db.laps_led", value: "Laps Led", comment: "Stat label")
        static let bestChamp = NSLocalizedString("f1db.best_champ", value: "Best Champ", comment: "Stat label")
        static let oneTwoFinishes = NSLocalizedString("f1db.one_two_finishes", value: "1-2 Finishes", comment: "Stat label")
        static let polePositions = NSLocalizedString("f1db.pole_positions", value: "Pole Positions", comment: "Stat label")
        static let bestResult = NSLocalizedString("f1db.best_result", value: "Best Result", comment: "Stat label")
        static let sprintWins = NSLocalizedString("f1db.sprint_wins", value: "Sprint Wins", comment: "Stat label")

        enum Qualifying {
            static let title = NSLocalizedString("f1db.qualifying.title", value: "Qualifying", comment: "Section title")
            static let pos = NSLocalizedString("f1db.qualifying.pos", value: "Pos", comment: "Table header")
            static let driver = NSLocalizedString("f1db.qualifying.driver", value: "Driver", comment: "Table header")
            static let q1 = NSLocalizedString("f1db.qualifying.q1", value: "Q1", comment: "Table header")
            static let q2 = NSLocalizedString("f1db.qualifying.q2", value: "Q2", comment: "Table header")
            static let q3 = NSLocalizedString("f1db.qualifying.q3", value: "Q3", comment: "Table header")
        }

        enum StartingGrid {
            static let title = NSLocalizedString("f1db.starting_grid.title", value: "Starting Grid", comment: "Section title")
            static func position(_ number: Int) -> String {
                String(format: NSLocalizedString("f1db.starting_grid.position", value: "P%d", comment: "Grid position"), number)
            }
        }

        enum PitStops {
            static let title = NSLocalizedString("f1db.pit_stops.title", value: "Pit Stops", comment: "Section title")
            static func lap(_ number: Int) -> String {
                String(format: NSLocalizedString("f1db.pit_stops.lap", value: "Lap %d", comment: "Lap number prefix"), number)
            }
        }

        enum DriverOfTheDay {
            static let title = NSLocalizedString("f1db.driver_of_the_day.title", value: "Driver of the Day", comment: "Section title")
            static func percentage(_ value: Double) -> String {
                String(format: NSLocalizedString("f1db.driver_of_the_day.percentage", value: "%.1f%% of votes", comment: "Vote percentage"), value)
            }
        }

        enum GrandPrix {
            static func round(_ count: Int) -> String {
                String(format: NSLocalizedString("f1db.grand_prix.round", value: "Round %d", comment: "Races held count"), count)
            }
            static func racesHeld(_ count: Int) -> String {
                String(format: NSLocalizedString("f1db.grand_prix.races_held", value: "%d races held", comment: "Grand Prix total races"), count)
            }
        }

        enum FastestLaps {
            static func lap(_ number: Int) -> String {
                String(format: NSLocalizedString("f1db.fastest_laps.lap", value: "Lap %d", comment: "Lap number prefix"), number)
            }
        }
    }
}
