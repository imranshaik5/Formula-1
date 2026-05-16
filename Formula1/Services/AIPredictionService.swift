import Foundation

struct AIConfig: Codable, Equatable {
    var endpoint: String
    var apiKey: String
    var model: String

    static let defaults = AIConfig(
        endpoint: "http://localhost:11434/v1/chat/completions",
        apiKey: "ollama",
        model: "llama3.2"
    )

    var isConfigured: Bool { !endpoint.isEmpty && !apiKey.isEmpty }
}

final class AIConfigStore: ObservableObject {
    static let shared = AIConfigStore()
    @Published var config: AIConfig {
        didSet { save() }
    }

    private init() {
        if let data = UserDefaults.standard.data(forKey: "ai_config"),
           let decoded = try? JSONDecoder().decode(AIConfig.self, from: data) {
            self.config = decoded
        } else {
            self.config = AIConfig.defaults
        }
    }

    private func save() {
        if let data = try? JSONEncoder().encode(config) {
            UserDefaults.standard.set(data, forKey: "ai_config")
        }
    }
}

struct AIPredictionResponse: Decodable {
    let predictions: [AIPredictionItem]
}

struct AIPredictionItem: Decodable {
    let driverId: String
    let predictedPosition: Int
    let winProbability: Double
    let reasoning: String?
    let factors: [APIFactor]?

    struct APIFactor: Decodable {
        let label: String
        let value: String
        let weight: Double
    }
}

@MainActor
struct AIPredictionService {
    let config: AIConfig
    let f1db: F1DBService

    func predictTop5(for race: F1DBRace?) async throws -> [DriverPrediction] {
        let prompt = buildPrompt(for: race)
        let messages: [[String: Any]] = [
            ["role": "system", "content": systemPrompt],
            ["role": "user", "content": prompt],
        ]
        let body: [String: Any] = [
            "model": config.model,
            "messages": messages,
            "temperature": 0.7,
            "response_format": ["type": "json_object"],
        ]

        var request = URLRequest(url: URL(string: config.endpoint)!)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(config.apiKey)", forHTTPHeaderField: "Authorization")
        request.httpBody = try JSONSerialization.data(withJSONObject: body)

        let (data, _) = try await URLSession.shared.data(for: request)

        let apiResponse = try JSONDecoder().decode(AIAPIResponse.self, from: data)
        guard let content = apiResponse.choices.first?.message.content,
              let contentData = content.data(using: .utf8) else {
            throw AIPredictionError.emptyResponse
        }
        let predictionResponse = try JSONDecoder().decode(AIPredictionResponse.self, from: contentData)
        let season = race.flatMap { f1db.season(year: $0.year) } ?? f1db.season(year: 2026)

        let rawProbs = predictionResponse.predictions.map { $0.winProbability }
        let temperature = 8.0
        let expScores = rawProbs.map { exp($0 * temperature) }
        let sumExp = expScores.reduce(0, +)
        let softmaxProbs = sumExp > 0 ? expScores.map { $0 / sumExp } : Array(repeating: 0, count: rawProbs.count)

        return predictionResponse.predictions.enumerated().map { index, item in
            let driver = f1db.driver(id: item.driverId)
            let constructorId = season?.drivers?.first { $0.driverId == item.driverId }?.constructorId
            let constructor = constructorId.flatMap { f1db.constructor(id: $0) }
            let teamName = constructor?.name ?? "Unknown"
            let prob = softmaxProbs[index]
            let factors = item.factors?.map { f in
                PredictionFactor(label: f.label, value: f.value, weight: f.weight)
            } ?? [
                PredictionFactor(label: "AI Analysis", value: "\(Int(prob * 100))%", weight: 0.5),
            ]
            return DriverPrediction(
                id: item.driverId,
                driverId: item.driverId,
                driverName: driver?.fullName ?? item.driverId.replacingOccurrences(of: "-", with: " ").capitalized,
                driverAbbreviation: driver?.abbreviation ?? "",
                teamName: teamName,
                score: prob * 100,
                predictedPosition: item.predictedPosition,
                winProbability: prob,
                factors: factors,
                reasoning: item.reasoning
            )
        }
    }

    private var systemPrompt: String {
        """
        You are an expert Formula 1 prediction analyst. Your task is to predict the top 5 finishers \
        for an upcoming race based on the provided data. You understand F1 deeply — you know driver \
        strengths, team performance, circuit characteristics, and season dynamics.

        Return valid JSON only (no markdown wrapping). Format:
        {
          "predictions": [
            {
              "driverId": "string",
              "predictedPosition": 1-5,
              "winProbability": 0.0-1.0,
              "reasoning": "1-2 sentence explanation",
              "factors": [
                {"label": "Career Form", "value": "85%", "weight": 0.25},
                {"label": "Season Form", "value": "75%", "weight": 0.25},
                {"label": "Circuit History", "value": "90%", "weight": 0.25},
                {"label": "Momentum", "value": "70%", "weight": 0.15},
                {"label": "Qualifying", "value": "80%", "weight": 0.10}
              ]
            }
          ]
        }

        The winProbability represents the chance of winning (0-1). Be decisive — differentiate clearly between \
        drivers. The top pick should be at least 0.15 higher than second. The factors represent the AI's \
        assessment of that driver across different dimensions (career form, season form, circuit history, \
        momentum, qualifying). Make sure the factor values reflect real differences between drivers.
        """
    }

    private func buildPrompt(for race: F1DBRace?) -> String {
        var lines: [String] = ["Predict the top 5 finishers for the upcoming F1 race.\n"]

        if let race {
            let circuit = f1db.circuit(id: race.circuitId)
            lines.append("Race: \(race.officialName) (\(race.year))")
            lines.append("Round: \(race.round)")
            lines.append("Circuit: \(circuit?.name ?? race.circuitId)")
            lines.append("Circuit Type: \(circuit?.type ?? "Unknown")")
            lines.append("Location: \(circuit?.placeName ?? "Unknown")")
            if let circuit {
                lines.append("Country: \(f1db.countryName(id: circuit.countryId))")
            }
            lines.append("")
        } else {
            lines.append("Race: Unknown (general prediction)")
            lines.append("")
        }

        let season: F1DBSeason?
        if let race {
            season = f1db.season(year: race.year)
        } else {
            season = f1db.season(year: 2026)
        }

        if let drivers = season?.drivers, !drivers.isEmpty {
            lines.append("=== SEASON DRIVERS ===")
            let standings = season?.driverStandings ?? []
            for sd in drivers {
                let driver = f1db.driver(id: sd.driverId)
                let constructor = sd.constructorId.flatMap { f1db.constructor(id: $0) }
                let standing = standings.first { $0.driverId == sd.driverId }
                let pos = standing?.positionNumber.map { "P\($0)" } ?? "N/A"
                let pts = standing?.points ?? 0
                lines.append("  \(driver?.abbreviation ?? "???") | \(driver?.fullName ?? sd.driverId) | \(constructor?.name ?? "???") | Season: \(pos) \(pts)pts")
            }
            lines.append("")
        }

        if let standings = season?.driverStandings, !standings.isEmpty {
            lines.append("=== CURRENT STANDINGS (TOP 10) ===")
            for s in standings.prefix(10) {
                let driver = f1db.driver(id: s.driverId)
                lines.append("  \(s.positionNumber ?? 99). \(driver?.abbreviation ?? s.driverId) — \(s.points)pts")
            }
            lines.append("")
        }

        if let race {
            let circuitRaces = f1db.racesAtCircuit(circuitId: race.circuitId)
            if !circuitRaces.isEmpty {
                lines.append("=== LAST 5 RACES AT THIS CIRCUIT ===")
                for r in circuitRaces.prefix(5) {
                    let winner = r.raceResults?.first { $0.positionNumber == 1 }?.driverId
                    let winnerName = winner.flatMap { f1db.driver(id: $0)?.abbreviation } ?? "?"
                    lines.append("  \(r.year) Rd\(r.round): Winner — \(winnerName)")
                }
                lines.append("")
            }
        }

        let activeDrivers: [F1DBDriver]
        if let season, let seasonDrivers = season.drivers {
            let ids = Set(seasonDrivers.map { $0.driverId })
            activeDrivers = f1db.allDrivers().filter { ids.contains($0.id) && $0.totalRaceEntries > 0 }
        } else {
            activeDrivers = f1db.allDrivers().filter { $0.totalRaceEntries > 0 }
        }

        lines.append("=== DRIVER CAREER STATS ===")
        for d in activeDrivers {
            let constructor = season?.drivers?.first { $0.driverId == d.id }?.constructorId
            let teamName = constructor.flatMap { f1db.constructor(id: $0)?.name } ?? "?"
            let winPct = d.totalRaceEntries > 0 ? Double(d.totalRaceWins) / Double(d.totalRaceEntries) * 100 : 0
            lines.append("  \(d.abbreviation) | \(teamName) | Wins: \(d.totalRaceWins)/\(d.totalRaceEntries) (\(Int(winPct))%) | Podiums: \(d.totalPodiums) | Poles: \(d.totalPolePositions) | Best Champ: P\(d.bestChampionshipPosition ?? 99) | Best Grid: P\(d.bestStartingGridPosition ?? 99)")
        }

        return lines.joined(separator: "\n")
    }
}

struct AIAPIResponse: Decodable {
    let choices: [AIAPIChoice]
}

struct AIAPIChoice: Decodable {
    let message: AIAPIMessage
}

struct AIAPIMessage: Decodable {
    let content: String
}

enum AIPredictionError: LocalizedError {
    case emptyResponse

    var errorDescription: String? {
        switch self {
        case .emptyResponse: return "AI returned an empty response."
        }
    }
}
