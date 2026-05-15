# Formula 1 iOS App

A dark-mode native iOS app for Formula 1 fans — race calendar, driver & constructor standings, driver profiles, and video content.

> **Note:** A demo video is bundled with the Xcode project at `Formula1/Resources/demo.mp4`. On GitHub, click below to view:

https://github.com/imranshaik5/Formula-1/releases/download/v1.0.0-preview/demo.mp4

Built with SwiftUI, Kingfisher, and Alamofire. Data sourced from [Jolpica](https://jolpica.com) (Ergast fork) and official F1 Media CDN.

## Features

- **Race Calendar** — Upcoming, live (3-hour window), and previous races with countdowns, circuit SVGs, and results (podium, race results, fastest lap, grid vs. finish)
- **Driver Standings** — Glassmorphism card list with team-colored glows, watermarked ranks, driver portraits, and team logos
- **Constructor Standings** — Team standings with color bars and championship headers
- **Driver Profiles** — Headshot, nationality flag, stats (wins, points bar, race count), career results, best moments, and YouTube video thumbnails
- **News** — News feed from The Race RSS
- **Dark Mode** — Carbon fiber backgrounds, frosted glass panels, gradient borders, team-colored accents
- **Navigation** — Coordinator pattern with deep linking between races, drivers, and constructors

## Architecture

- **MVVM + Coordinator** — Views observe ViewModels; AppCoordinator manages navigation stack
- **Protocol-oriented services** — `RaceServiceProtocol`, `DriverServiceProtocol`, `ConstructorServiceProtocol`, `NewsServiceProtocol`
- **Dark design system** — `F1Theme` (colors, fonts, spacing) and `F1TeamColor` (per-team hex codes)

## Data Sources

| Source | Usage |
|--------|-------|
| [Jolpica API](https://jolpica.com) | Race calendar, driver standings, constructor standings, race results |
| [F1 Media CDN](https://media.formula1.com) | Driver headshots, team logos, car images |
| YouTube (scraped) | Driver/team video thumbnails via `ytInitialData` |
| [f1-circuits-svg](https://github.com/julesr0y/f1-circuits-svg) | Circuit track maps |
| [The Race RSS](https://the-race.com) | News articles |

## Requirements

- iOS 17.0+
- Xcode 15.0+
- Swift 5.9+

## Setup

1. Clone the repository
2. Open `Formula1.xcodeproj` in Xcode
3. Let Swift Package Manager resolve dependencies (Kingfisher, Alamofire)
4. Build and run

## Dependencies

- [Kingfisher](https://github.com/onevcat/Kingfisher) — Image caching and loading
- [Alamofire](https://github.com/Alamofire/Alamofire) — HTTP networking

## Design

- Full dark mode with `preferredColorScheme(.dark)`
- Glassmorphism: `ultraThinMaterial` frosted panels, team-color gradient borders, carbon fiber background
- Per-team colors: Papaya (McLaren), Rosso Corsa (Ferrari), Teal (Mercedes), etc.
- Watermarked rank numbers at 13% opacity behind driver cards
- PTS monospaced numerals for standings positions with tracking(2)

## 2026 Season Support

- Updated team slug mappings for all 2026 teams (Cadillac, Audi, Racing Bulls, etc.)
- Partial-name fallbacks (`teamName.lowercased().contains(...)`) for API name variants
- Cadillac and Audi color schemes and mock data

## Team Colors

```swift
McLaren    #F47600 (Papaya)
Ferrari    #ED1131 (Rosso Corsa)
Red Bull   #4781D7
Mercedes   #00D7B6 (Teal)
Aston Martin #229971
Alpine     #00A1E8
Racing Bulls #6C98FF
Williams   #1868DB
Sauber     #01C00E
Haas       #9C9FA2
Cadillac   #1A1A2E
Audi       #1A1A1A
```
