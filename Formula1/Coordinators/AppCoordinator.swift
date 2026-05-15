import SwiftUI

enum AppRoute: Hashable {
    case raceDetail(Race)
    case driverDetail(Driver)
    case constructorDetail(ConstructorStanding)
}

@MainActor
final class AppCoordinator: ObservableObject {
    @Published var navigationPath = NavigationPath()

    private let raceService: RaceServiceProtocol
    private let driverService: DriverServiceProtocol
    private let constructorService: ConstructorServiceProtocol

    init(
        raceService: RaceServiceProtocol = RaceService(),
        driverService: DriverServiceProtocol = DriverService(),
        constructorService: ConstructorServiceProtocol = ConstructorService()
    ) {
        self.raceService = raceService
        self.driverService = driverService
        self.constructorService = constructorService
    }
}

extension AppCoordinator: Coordinator {
    typealias Route = AppRoute

    func navigate(to route: AppRoute) {
        navigationPath.append(route)
    }
}

extension AppCoordinator {
    @ViewBuilder
    func view(for route: AppRoute) -> some View {
        switch route {
        case .raceDetail(let race):
            RaceDetailView(
                viewModel: RaceDetailViewModel(race: race, raceService: raceService),
                onDriverTap: { [weak self] driver in
                    self?.navigate(to: .driverDetail(driver))
                }
            )
        case .driverDetail(let driver):
            DriverDetailView(
                viewModel: DriverDetailViewModel(driver: driver, driverService: driverService)
            )
        case .constructorDetail(let standing):
            ConstructorDetailView(standing: standing)
        }
    }
}

extension AppCoordinator {
    func makeRaceListView() -> RaceListView {
        RaceListView(
            viewModel: RaceListViewModel(raceService: raceService),
            onRaceTap: { [weak self] race in
                self?.navigate(to: .raceDetail(race))
            }
        )
    }

    func makeDriverListView() -> DriverListView {
        DriverListView(
            viewModel: DriverListViewModel(driverService: driverService),
            onDriverTap: { [weak self] driver in
                self?.navigate(to: .driverDetail(driver))
            }
        )
    }

    func makeConstructorStandingsView() -> ConstructorStandingsView {
        ConstructorStandingsView(
            viewModel: ConstructorStandingsViewModel(constructorService: constructorService),
            onConstructorTap: { [weak self] standing in
                self?.navigate(to: .constructorDetail(standing))
            }
        )
    }

    func makeNewsListView() -> NewsListView {
        NewsListView(
            viewModel: NewsViewModel(newsService: NewsService())
        )
    }
}
