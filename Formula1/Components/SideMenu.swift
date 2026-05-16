import SwiftUI

struct SideMenu: View {
    @Binding var isOpen: Bool
    @Binding var selectedTab: SideMenuTab

    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                if isOpen {
                    overlay
                }

                menuPanel(geometry: geometry)
            }
        }
    }

    private var overlay: some View {
        Color.black.opacity(0.3)
            .ignoresSafeArea()
            .onTapGesture { toggle() }
            .transition(.opacity)
    }

    private func menuPanel(geometry: GeometryProxy) -> some View {
        HStack(spacing: 0) {
            menuContent
                .frame(width: geometry.size.width * 0.75)
                .background(.ultraThinMaterial)
                .background(
                    LinearGradient(
                        colors: [.f1Accent.opacity(0.06), .clear],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
                .clipShape(
                    UnevenRoundedRectangle(
                        topLeadingRadius: 0, bottomLeadingRadius: 0,
                        bottomTrailingRadius: 20, topTrailingRadius: 20
                    )
                )
                .overlay(
                    Rectangle()
                        .frame(width: 1)
                        .foregroundStyle(
                            LinearGradient(
                                colors: [.clear, .f1Accent.opacity(0.4), .clear],
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        ),
                    alignment: .trailing
                )
                .shadow(color: .black.opacity(0.4), radius: 20, x: 4, y: 0)

            Spacer(minLength: 0)
        }
        .offset(x: isOpen ? 0 : -geometry.size.width * 0.75)
        .animation(.spring(response: 0.4, dampingFraction: 0.85), value: isOpen)
    }

    private var menuContent: some View {
        VStack(alignment: .leading, spacing: 0) {
            header
            Spacer().frame(height: 32)
            menuItems
            Spacer()
            footer
        }
        .padding(.top, 60)
        .padding(.horizontal, 16)
    }

    private var header: some View {
        HStack(spacing: 10) {
            logoContainer
            headerText
        }
    }

    private var logoContainer: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 8)
                .fill(.ultraThinMaterial)
                .frame(width: 44, height: 44)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.white.opacity(0.1), lineWidth: 1)
                )

            AsyncImage(url: URL(string: "https://media.formula1.com/etc/designs/fom-website/images/f1_logo.png")) { phase in
                switch phase {
                case .success(let image):
                    image
                        .resizable()
                        .scaledToFit()
                        .frame(width: 28, height: 28)
                case .failure:
                    Text(Strings.SideMenu.f1Fallback)
                        .font(.system(size: 18, weight: .black, design: .rounded))
                        .foregroundColor(.f1Accent)
                case .empty:
                    Text(Strings.SideMenu.f1Fallback)
                        .font(.system(size: 18, weight: .black, design: .rounded))
                        .foregroundColor(.f1Accent)
                @unknown default:
                    EmptyView()
                }
            }
        }
    }

    private var headerText: some View {
        VStack(alignment: .leading, spacing: 1) {
            Text("FORMULA 1")
                .font(.system(size: 16, weight: .black, design: .rounded))
                .foregroundColor(.white)

            Text("2026 Season")
                .font(.system(size: 11, weight: .medium, design: .rounded))
                .foregroundColor(.f1TextSecondary)
        }
    }

    private var menuItems: some View {
        VStack(spacing: 6) {
            ForEach(SideMenuTab.allCases, id: \.self) { tab in
                menuRow(tab)
            }
        }
    }

    private func menuRow(_ tab: SideMenuTab) -> some View {
        Button(action: {
            selectedTab = tab
            toggle()
        }, label: {
            menuRowLabel(tab)
        })
    }

    private func menuRowLabel(_ tab: SideMenuTab) -> some View {
        HStack(spacing: 14) {
            iconContainer(tab)
            Text(tab.title)
                .font(.system(size: 16, weight: selectedTab == tab ? .bold : .medium, design: .rounded))
                .foregroundColor(selectedTab == tab ? .white : .f1TextSecondary)
            Spacer()
            if selectedTab == tab {
                Capsule()
                    .fill(Color.f1Accent)
                    .frame(width: 4, height: 20)
            }
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 10)
        .background {
            if selectedTab == tab {
                RoundedRectangle(cornerRadius: 12)
                    .fill(.ultraThinMaterial)
            }
        }
        .overlay {
            if selectedTab == tab {
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.white.opacity(0.08), lineWidth: 1)
            }
        }
    }

    private func iconContainer(_ tab: SideMenuTab) -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: 8)
                .fill(Color.f1Accent)
                .frame(width: 36, height: 36)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.white.opacity(0.06), lineWidth: 1)
                )
                .opacity(selectedTab == tab ? 1 : 0)

            RoundedRectangle(cornerRadius: 8)
                .fill(.ultraThinMaterial)
                .frame(width: 36, height: 36)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.white.opacity(0.06), lineWidth: 1)
                )
                .opacity(selectedTab == tab ? 0 : 1)

            Image(systemName: tab.icon)
                .font(.system(size: 15, weight: .semibold))
                .foregroundColor(selectedTab == tab ? .white : .f1TextSecondary)
        }
    }

    private var footer: some View {
        VStack(spacing: 6) {
            Divider()
                .overlay(Color.white.opacity(0.06))

            HStack(spacing: 6) {
                Image(systemName: "clock.arrow.circlepath")
                    .font(.system(size: 10))
                    .foregroundColor(.f1TextMuted)

                Text(Strings.SideMenu.historicalData)
                    .font(.system(size: 11, weight: .medium, design: .rounded))
                    .foregroundColor(.f1TextMuted)
            }

            Text(Strings.SideMenu.version)
                .font(.system(size: 10, weight: .regular, design: .rounded))
                .foregroundColor(.f1TextMuted.opacity(0.6))
        }
        .padding(.bottom, 20)
    }

    private func toggle() {
        withAnimation(.spring(response: 0.4, dampingFraction: 0.85)) {
            isOpen.toggle()
        }
    }
}

enum SideMenuTab: String, CaseIterable {
    case races
    case drivers
    case constructors
    case news

    var title: String {
        switch self {
        case .races: return Strings.SideMenu.raceCalendar
        case .drivers: return Strings.SideMenu.drivers
        case .constructors: return Strings.SideMenu.constructors
        case .news: return Strings.SideMenu.news
        }
    }

    var icon: String {
        switch self {
        case .races: return "flag.checkered"
        case .drivers: return "person.3.fill"
        case .constructors: return "wrench.and.screwdriver.fill"
        case .news: return "newspaper.fill"
        }
    }
}
