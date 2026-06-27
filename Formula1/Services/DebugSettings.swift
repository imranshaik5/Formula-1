import Foundation
import Combine

final class DebugSettingsStore: ObservableObject {
    static let shared = DebugSettingsStore()

    @Published var mockModeEnabled: Bool {
        didSet { UserDefaults.standard.set(mockModeEnabled, forKey: "debug_mockMode") }
    }
    @Published var forceLiveRace: Bool {
        didSet { UserDefaults.standard.set(forceLiveRace, forKey: "debug_forceLive") }
    }

    private init() {
        let defaults = UserDefaults.standard
        mockModeEnabled = defaults.bool(forKey: "debug_mockMode")
        forceLiveRace = defaults.bool(forKey: "debug_forceLive")
    }
}
