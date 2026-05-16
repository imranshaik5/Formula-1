import SwiftUI

struct PreviewWrapper<Content: View>: View {
    let content: Content

    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }

    var body: some View {
        content
            .environmentObject(F1DBService.shared)
            .preferredColorScheme(.dark)
    }
}

// MARK: - Preview ViewModels

extension RaceListViewModel {
    static var preview: RaceListViewModel {
        let vm = RaceListViewModel(raceService: RaceService())
        vm.state = .loaded([
            PreviewData.race,
            PreviewData.completedRace,
        ])
        return vm
    }
}

extension RaceDetailViewModel {
    static func preview(for race: Race) -> RaceDetailViewModel {
        let vm = RaceDetailViewModel(race: race, raceService: RaceService())
        vm.loadState = .loaded(())
        return vm
    }
}

extension DriverListViewModel {
    static var preview: DriverListViewModel {
        let vm = DriverListViewModel(driverService: DriverService())
        vm.state = .loaded([PreviewData.driver, PreviewData.driver2, PreviewData.driver3])
        return vm
    }
}

extension DriverDetailViewModel {
    static var preview: DriverDetailViewModel {
        let vm = DriverDetailViewModel(driver: PreviewData.driver, driverService: DriverService())
        vm.loadState = .loaded(())
        return vm
    }
}

extension ConstructorStandingsViewModel {
    static var preview: ConstructorStandingsViewModel {
        let vm = ConstructorStandingsViewModel(constructorService: ConstructorService())
        vm.state = .loaded([PreviewData.constructorStanding])
        return vm
    }
}

extension ConstructorDetailViewModel {
    static var preview: ConstructorDetailViewModel {
        let vm = ConstructorDetailViewModel(standing: PreviewData.constructorStanding, constructorService: ConstructorService())
        vm.state = .loaded(())
        return vm
    }
}

extension NewsViewModel {
    static var preview: NewsViewModel {
        let vm = NewsViewModel(newsService: NewsService())
        vm.state = .loaded(PreviewData.articles)
        return vm
    }
}
