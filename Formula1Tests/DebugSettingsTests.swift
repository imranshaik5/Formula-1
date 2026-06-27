import Testing
import Foundation
@testable import Formula1

struct DebugSettingsTests {
    init() {
        let defaults = UserDefaults.standard
        defaults.removeObject(forKey: "debug_mockMode")
        defaults.removeObject(forKey: "debug_forceLive")
    }

    @Test func defaultsAreCorrect() {
        let settings = DebugSettingsStore.shared
        #expect(!settings.mockModeEnabled)
        #expect(!settings.forceLiveRace)
    }

    @Test func mockModeTogglePersists() {
        let settings = DebugSettingsStore.shared
        settings.mockModeEnabled = true
        #expect(settings.mockModeEnabled)
        settings.mockModeEnabled = false
        #expect(!settings.mockModeEnabled)
    }

    @Test func forceLiveTogglePersists() {
        let settings = DebugSettingsStore.shared
        settings.forceLiveRace = true
        #expect(settings.forceLiveRace)
        settings.forceLiveRace = false
        #expect(!settings.forceLiveRace)
    }

    @Test func togglesAreIndependent() {
        let settings = DebugSettingsStore.shared
        settings.mockModeEnabled = false
        settings.forceLiveRace = false
        settings.mockModeEnabled = true
        settings.forceLiveRace = true
        #expect(settings.mockModeEnabled)
        #expect(settings.forceLiveRace)
        settings.mockModeEnabled = false
        #expect(!settings.mockModeEnabled)
        #expect(settings.forceLiveRace)
        settings.forceLiveRace = false
        #expect(!settings.forceLiveRace)
    }
}
