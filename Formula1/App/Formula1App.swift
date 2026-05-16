import SwiftUI

@main
struct Formula1App: App {
    @StateObject private var coordinator = AppCoordinator()
    @StateObject private var f1dbService = F1DBService.shared
    @State private var showSplash = true
    @State private var menuOpen = false
    @State private var selectedTab: SideMenuTab = .races

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
                ZStack {
                    mainContent
                    SideMenu(isOpen: $menuOpen, selectedTab: $selectedTab)
                }
                .environmentObject(coordinator)
                .environmentObject(f1dbService)
                .environmentObject(AIConfigStore.shared)
                .preferredColorScheme(.dark)
                .transition(.opacity)
            }
        }
    }

    @ViewBuilder
    private var mainContent: some View {
        NavigationStack(path: $coordinator.navigationPath) {
            Group {
                switch selectedTab {
                case .races:
                    coordinator.makeRaceListView()
                case .drivers:
                    coordinator.makeDriverListView()
                case .constructors:
                    coordinator.makeConstructorStandingsView()
                case .news:
                    coordinator.makeNewsListView()
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        withAnimation(.spring(response: 0.4, dampingFraction: 0.85)) {
                            menuOpen.toggle()
                        }
                    } label: {
                        Image(systemName: "line.3.horizontal")
                            .font(.system(size: 20, weight: .semibold))
                            .foregroundColor(.white)
                    }
                }
            }
            .navigationDestination(for: AppRoute.self) { route in
                coordinator.view(for: route)
            }
        }
        .tint(.f1Accent)
    }
}
