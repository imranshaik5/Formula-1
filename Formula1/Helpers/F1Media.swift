import Foundation

enum F1Media {
    static let logoURL = URL(string: "https://media.formula1.com/etc/designs/fom-website/images/f1_logo.svg")!
    static let logoImageURL = URL(string: "https://img.icons8.com/ios-filled/120/FFFFFF/formula-1.png")!

    static let carImageURL = URL(string: "https://media.formula1.com/image/upload/c_lfill,w_512/q_auto/d_common:f1:2026:fallback:car:2026fallbackcarright.webp/v1740000001/common/f1/2026/redbullracing/2026redbullracingcarright.webp")!

    static func driverPhotoURL(driverName: String, season: Int = 2025) -> URL {
        let ref = driverRef(for: driverName)
        return URL(string: "https://media.formula1.com/content/dam/fom-website/2018-redesign-assets/drivers/\(season)/\(ref).png")!
    }

    private static func driverRef(for name: String) -> String {
        let normalized = name.folding(options: .diacriticInsensitive, locale: .current)
        let parts = normalized.split(separator: " ")
        let first = parts.first?.prefix(3).uppercased() ?? ""
        let last = parts.dropFirst().first?.prefix(3).uppercased() ?? ""
        return "\(first)\(last)01"
    }

    static func teamLogoURL(teamSlug: String, year: Int = 2026) -> URL {
        URL(string: "https://media.formula1.com/image/upload/c_lfill,w_48/q_auto/v1740000001/common/f1/\(year)/\(teamSlug)/\(year)\(teamSlug)logowhite.webp")!
    }

    static func circuitSVGURL(circuitName: String) -> URL {
        let circuitID = circuitSlug(for: circuitName)
        return URL(string: "https://raw.githubusercontent.com/julesr0y/f1-circuits-svg/main/circuits/minimal/white/\(circuitID)-1.svg")!
    }

    static func circuitSlug(for circuitName: String) -> String {
        let lower = circuitName.lowercased()
        if lower.contains("albert park") || lower.contains("melbourne") { return "melbourne" }
        if lower.contains("shanghai") { return "shanghai" }
        if lower.contains("miami") { return "miami" }
        if lower.contains("imola") || lower.contains("enzo") { return "imola" }
        if lower.contains("monaco") { return "monaco" }
        if lower.contains("gilles villeneuve") || lower.contains("montreal") { return "montreal" }
        if lower.contains("catalunya") || lower.contains("barcelona") { return "catalunya" }
        if lower.contains("red bull ring") || lower.contains("spielberg") { return "spielberg" }
        if lower.contains("silverstone") { return "silverstone" }
        if lower.contains("hungaroring") || lower.contains("budapest") { return "hungaroring" }
        if lower.contains("spa") || lower.contains("francorchamps") { return "spa-francorchamps" }
        if lower.contains("zandvoort") { return "zandvoort" }
        if lower.contains("monza") { return "monza" }
        if lower.contains("marina bay") || lower.contains("singapore") { return "marina-bay" }
        if lower.contains("suzuka") || lower.contains("japan") { return "suzuka" }
        if lower.contains("lusail") || lower.contains("losail") || lower.contains("qatar") { return "lusail" }
        if lower.contains("americas") || lower.contains("austin") { return "austin" }
        if lower.contains("hermanos") || lower.contains("mexico") { return "mexico-city" }
        if lower.contains("interlagos") || lower.contains("são paulo") || lower.contains("brazil") { return "interlagos" }
        if lower.contains("yas marina") || lower.contains("abu dhabi") { return "yas-marina" }
        if lower.contains("baku") || lower.contains("azerbaijan") { return "baku" }
        if lower.contains("jeddah") || lower.contains("saudi") { return "jeddah" }
        if lower.contains("bahrain") || lower.contains("sakhir") { return "bahrain" }
        if lower.contains("vegas") || lower.contains("las vegas") || lower.contains("nevada") { return "las-vegas" }
        if lower.contains("portimao") || lower.contains("algarve") { return "portimao" }
        if lower.contains("istanbul") || lower.contains("turkey") { return "istanbul" }
        if lower.contains("sochi") || lower.contains("russia") { return "sochi" }
        if lower.contains("sepang") || lower.contains("malaysia") { return "sepang" }
        return circuitName.lowercased().replacingOccurrences(of: " ", with: "-")
    }

    static func teamSlug(for teamName: String) -> String {
        let mapping: [String: String] = [
            "Red Bull": "redbullracing",
            "Red Bull Racing": "redbullracing",
            "Mercedes": "mercedes",
            "Ferrari": "ferrari",
            "McLaren": "mclaren",
            "McLaren Mercedes": "mclaren",
            "Aston Martin": "astonmartin",
            "Alpine F1 Team": "alpine",
            "Alpine": "alpine",
            "Williams": "williams",
            "RB F1 Team": "racingbulls",
            "RB": "racingbulls",
            "MoneyGram Haas F1 Team": "haas",
            "Haas": "haas",
            "Kick Sauber": "kicksauber",
            "Sauber": "kicksauber",
            "Stake F1 Team Kick Sauber": "kicksauber",
            "Cadillac": "cadillac",
            "Cadillac F1": "cadillac",
            "Cadillac F1 Team": "cadillac",
            "Cadillac Formula 1 Team": "cadillac",
            "Cadillac Racing": "cadillac",
            "Audi": "audi",
            "Haas F1 Team": "haas",
        ]

        if let slug = mapping[teamName] {
            return slug
        }
        let lower = teamName.lowercased()
        if lower.contains("cadillac") { return "cadillac" }
        if lower.contains("red bull") { return "redbullracing" }
        if lower.contains("audi") { return "audi" }
        if lower.contains("rb ") || lower.contains("racing bulls") || lower.contains("vcarb") || lower == "rb" { return "racingbulls" }
        if lower.contains("haas") { return "haas" }
        if lower.contains("sauber") || lower.contains("stake") || lower.contains("kick") { return "kicksauber" }

        return teamName.lowercased().replacingOccurrences(of: " ", with: "")
    }
}
