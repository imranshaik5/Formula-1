import SwiftUI

@main
struct Formula1App: App {
    @StateObject private var coordinator = AppCoordinator()
    @State private var showSplash = true

    var body: some Scene {
        WindowGroup {
            if showSplash {
                SplashScreenView {
                    withAnimation(.easeInOut(duration: 0.35)) {
                        showSplash = false
                    }
                }
                .transition(.opacity)
            } else {
                NavigationStack(path: $coordinator.navigationPath) {
                    TabView {
                        coordinator.makeRaceListView()
                            .tabItem {
                                Label("Races", systemImage: "flag.checkered")
                            }
                            .toolbarBackground(.visible, for: .tabBar)
                            .toolbarBackground(F1Theme.cardBackground, for: .tabBar)

                        coordinator.makeDriverListView()
                            .tabItem {
                                Label("Drivers", systemImage: "person.3.fill")
                            }
                            .toolbarBackground(.visible, for: .tabBar)
                            .toolbarBackground(F1Theme.cardBackground, for: .tabBar)

                        coordinator.makeConstructorStandingsView()
                            .tabItem {
                                Label("Constructors", systemImage: "wrench.and.screwdriver.fill")
                            }
                            .toolbarBackground(.visible, for: .tabBar)
                            .toolbarBackground(F1Theme.cardBackground, for: .tabBar)

                        coordinator.makeNewsListView()
                            .tabItem {
                                Label("News", systemImage: "newspaper.fill")
                            }
                            .toolbarBackground(.visible, for: .tabBar)
                            .toolbarBackground(F1Theme.cardBackground, for: .tabBar)
                    }
                    .tint(.f1Accent)
                    .navigationDestination(for: AppRoute.self) { route in
                        coordinator.view(for: route)
                    }
                }
                .environmentObject(coordinator)
                .preferredColorScheme(.dark)
                .transition(.opacity)
            }
        }
    }
}
