# Formula 1 iOS App

A dark-mode native iOS app for Formula 1 fans — race calendar, driver & constructor standings, driver profiles, video content, and **AI-powered race predictions**.

> **Note:** A demo video is bundled with the Xcode project at `Formula1/Resources/demo.mp4`. On GitHub, click below to view:

https://github.com/user-attachments/assets/7c69a22e-63c2-43a7-a238-8f21f60704cb

Built with SwiftUI, Kingfisher, and Alamofire. Race data sourced from the [F1DB](https://github.com/f1db/f1db) historical database (1950–2026, 83M JSON) with live data from [Jolpica](https://jolpica.com) (Ergast fork) and images from the official F1 Media CDN.

## Features

- **Race Calendar** — Upcoming, live (3-hour window), and previous races with countdowns, circuit SVGs, and results (podium, race results, fastest lap, grid vs. finish)
- **AI Race Predictions** — Top-5 predictions for upcoming races powered by a local LLM (Ollama/Llama) or any OpenAI-compatible API. Animated loading, per-driver reasoning, factor breakdown (career form, season form, circuit history, momentum, qualifying). Falls back to a data-driven statistical engine when no AI is configured.
- **Driver Standings** — Glassmorphism card list with team-colored glows, watermarked ranks, driver portraits, and team logos
- **Constructor Standings** — Team standings with color bars and championship headers
- **Driver Profiles** — Headshot, nationality flag, stats (wins, points bar, race count), career results, best moments, and YouTube video thumbnails
- **Historical Race Data** — Qualifying results, starting grids, fastest laps, pit stops, driver of the day for all past races
- **News** — News feed from The Race RSS with AI-generated summaries
- **Dark Mode** — Carbon fiber backgrounds, frosted glass panels, gradient borders, team-colored accents
- **Navigation** — Coordinator pattern with deep linking between races, drivers, and constructors

## AI Predictions

Predictions appear on the Race Detail screen for any upcoming race. The app ships with a **data-driven fallback engine** that scores drivers across five dimensions (career, season, circuit history, momentum, qualifying) using 1171 historical races from the bundled F1DB.

For real AI-powered predictions, configure a local or cloud LLM:

| Provider | Endpoint | Model | Setup |
|----------|----------|-------|-------|
| **Ollama** (local) | `http://localhost:11434/v1/chat/completions` | `llama3.2` | `brew install ollama && ollama pull llama3.2` |
| **Groq** (cloud) | `https://api.groq.com/openai/v1/chat/completions` | `llama-3.3-70b-versatile` | Free key at https://console.groq.com/keys |
| **Together AI** | `https://api.together.xyz/v1/chat/completions` | `meta-llama/Llama-3.3-70B-Instruct-Turbo` | Free credits at https://api.together.ai/settings/api-keys |

Tap the gear icon on the "AI Predictions" card to enter your endpoint, API key, and model. Predictions include per-driver win probability, factor breakdown bars, and AI reasoning text.

## Architecture

- **MVVM + Coordinator** — Views observe ViewModels; AppCoordinator manages navigation stack
- **Protocol-oriented services** — `RaceServiceProtocol`, `DriverServiceProtocol`, `ConstructorServiceProtocol`, `NewsServiceProtocol`
- **Dark design system** — `F1Theme` (colors, fonts, spacing) and `F1TeamColor` (per-team hex codes)

## Data Sources

| Source | Usage |
|--------|-------|
| [F1DB](https://github.com/f1db/f1db) | 83MB historical database (1950–2026): drivers, constructors, circuits, race results, qualifying, pit stops |
| [Jolpica API](https://jolpica.com) | Live race calendar, driver standings, constructor standings |
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

*Optional:* To enable AI predictions, install [Ollama](https://ollama.ai) or get a free Groq API key.

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
