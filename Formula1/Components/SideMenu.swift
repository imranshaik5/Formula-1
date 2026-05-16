import SwiftUI

struct SideMenu: View {
    @Binding var isOpen: Bool
    @Binding var selectedTab: SideMenuTab

    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                if isOpen {
                    Color.black.opacity(0.4)
                        .ignoresSafeArea()
                        .onTapGesture { toggle() }
                        .transition(.opacity)
                }

                HStack(spacing: 0) {
                    menuContent
                        .frame(width: geometry.size.width * 0.75)
                        .background(
                            ZStack {
                                Color.f1Background
                                LinearGradient(
                                    colors: [.f1Accent.opacity(0.08), .clear],
                                    startPoint: .top,
                                    endPoint: .bottom
                                )
                            }
                            .ignoresSafeArea()
                        )
                        .overlay(
                            Rectangle()
                                .frame(width: 1)
                                .foregroundStyle(
                                    LinearGradient(
                                        colors: [
                                            .clear,
                                            .f1Accent.opacity(0.5),
                                            .clear,
                                        ],
                                        startPoint: .top,
                                        endPoint: .bottom
                                    )
                                ),
                            alignment: .trailing
                        )

                    Spacer(minLength: 0)
                }
                .offset(x: isOpen ? 0 : -geometry.size.width * 0.75)
                .animation(.spring(response: 0.4, dampingFraction: 0.85), value: isOpen)
            }
        }
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
        .padding(.horizontal, 20)
    }

    private var header: some View {
        HStack(spacing: 8) {
            AsyncImage(url: URL(string: "https://media.formula1.com/etc/designs/fom-website/images/f1_logo.png")) { phase in
                switch phase {
                case .success(let image):
                    image
                        .resizable()
                        .scaledToFit()
                        .frame(height: 32)
                case .failure:
                    Text("F1")
                        .font(.system(size: 28, weight: .black, design: .rounded))
                        .foregroundColor(.f1Accent)
                case .empty:
                    Text("F1")
                        .font(.system(size: 28, weight: .black, design: .rounded))
                        .foregroundColor(.f1Accent)
                @unknown default:
                    EmptyView()
                }
            }
            Text("2026")
                .font(.system(size: 18, weight: .bold, design: .rounded))
                .foregroundColor(.f1TextSecondary)
        }
    }

    private var menuItems: some View {
        VStack(spacing: 4) {
            ForEach(SideMenuTab.allCases, id: \.self) { tab in
                menuRow(tab)
            }
        }
    }

    private func menuRow(_ tab: SideMenuTab) -> some View {
        Button {
            selectedTab = tab
            toggle()
        } label: {
            HStack(spacing: 14) {
                Image(systemName: tab.icon)
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(selectedTab == tab ? .f1Accent : .f1TextSecondary)
                    .frame(width: 28)

                Text(tab.title)
                    .font(.system(size: 17, weight: selectedTab == tab ? .bold : .medium, design: .rounded))
                    .foregroundColor(selectedTab == tab ? .white : .f1TextSecondary)

                Spacer()

                if selectedTab == tab {
                    Capsule()
                        .fill(Color.f1Accent)
                        .frame(width: 4, height: 24)
                }
            }
            .padding(.vertical, 12)
            .padding(.horizontal, 12)
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(selectedTab == tab ? Color.f1Accent.opacity(0.12) : .clear)
            )
        }
    }

    private var footer: some View {
        VStack(spacing: 6) {
            Divider()
                .overlay(Color.f1Card)
            Text("F1DB Historical Data")
                .font(.system(size: 11, weight: .medium, design: .rounded))
                .foregroundColor(.f1TextMuted)
            Text("v2026.4.2")
                .font(.system(size: 10, weight: .regular, design: .rounded))
                .foregroundColor(.f1TextMuted)
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
        case .races: return "Race Calendar"
        case .drivers: return "Drivers"
        case .constructors: return "Constructors"
        case .news: return "News"
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
