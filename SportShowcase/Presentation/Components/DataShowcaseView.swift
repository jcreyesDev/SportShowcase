import SwiftUI
import SwiftData

struct DataShowcaseView: View {
    
    @State private var currentPage = 0
    
    private struct DataComponent: Identifiable {
        let id: Int
        let name: String
    }
    
    private let components = [
        DataComponent(id: 0, name: "List"),
        DataComponent(id: 1, name: "Standings Table"),
        DataComponent(id: 2, name: "Grid")
    ]
    
    var body: some View {
        VStack(spacing: 0) {
            VStack(spacing: DSSpacing.xs) {
                Text(components[currentPage].name)
                    .font(DSFont.subheadline)
                    .fontWeight(.medium)
                    .foregroundStyle(DSColor.Text.primary)
                    .animation(.easeInOut(duration: 0.2), value: currentPage)
                
                DSPageIndicator(currentPage: $currentPage,
                                pageCount: components.count,
                                style: .dots,
                                tintColor: DSColor.accent)
            }
            .pagerCoachMarkTarget(id: "cm_pager")
            .padding(.vertical, DSSpacing.sm)
            .frame(maxWidth: .infinity)
            .background(DSColor.Background.card)
            
            DSDivider()
            
            TabView(selection: $currentPage) {
                ForEach(components) { component in
                    ScrollView {
                        playgroundContent(for: component.id)
                            .padding(.bottom, DSSpacing.xl)
                    }
                    .tag(component.id)
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            .animation(.spring(response: 0.4, dampingFraction: 0.85), value: currentPage)
        }
        .navigationTitle("Data")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    @ViewBuilder
    private func playgroundContent(for index: Int) -> some View {
        switch index {
            case 0: ListPlayground()
            case 1: StandingsPlayground()
            case 2: GridPlayground()
            default: EmptyView()
        }
    }
}

    // MARK: - List Playground
private struct ListPlayground: View {
    
    @Query private var teams: [Team]
    @State private var accessoryIdx = 0
    @State private var showHeader   = true
    @State private var toggle1      = true
    @State private var toggle2      = false
    
    private let accessoryNames = ["Chevron", "Toggle", "Badge", "None"]
    
    private let info = ComponentInfo(
        name: "List",
        description: "Lists display rows of related content in a structured format with optional headers, footers, and accessories.",
        usageScenarios: [
            UsageScenario(icon: "list.bullet", title: "Settings",
                          description: "Display settings options with icons and accessories."),
            UsageScenario(icon: "shield", title: "Team lists",
                          description: "Browse teams or players with tap navigation.")
        ],
        configurability: "3 styles, optional header/footer, 4 accessory types.",
        bestPractices: [
            "Use inset grouped for iOS-native settings appearance.",
            "Always provide chevron for navigable items.",
            "Group related items under a common header."
        ]
    )
    
    private func makeItems() -> [DSListItem] {
        teams.prefix(4).enumerated().map { index, team in
            DSListItem(id: team.id,
                       title: team.name,
                       subtitle: team.city,
                       icon: "shield.fill",
                       iconColor: DSColor.accent,
                       accessory: accessory(for: index),
                       onTap: {})
        }
    }
    
    private func accessory(for index: Int) -> DSListItemAccessory {
        switch accessoryIdx {
            case 0: return .chevron
            case 1: return .toggle(index % 2 == 0 ? $toggle1 : $toggle2)
            case 2: return .badge(index == 0 ? "New" : "\(index + 1)")
            default: return .none
        }
    }
    
    var body: some View {
        ComponentPlaygroundView(info: info) {
            if teams.isEmpty {
                DSEmptyState(title: "No teams",
                             message: "Run the app to load data",
                             icon: "shield",
                             style: .compact,
                             iconColor: DSColor.accent)
            } else {
                DSList(items: makeItems(),
                       header: showHeader ? "Teams" : nil)
            }
        } controls: {
            CompactControlRow(title: "Accessory",
                              options: accessoryNames,
                              selected: $accessoryIdx)
            CompactToggleRow(title: "Show header", isOn: $showHeader)
        }
    }
}

    // MARK: - Standings Playground
private struct StandingsPlayground: View {
    
    @State private var highlightIdx = 0
    @State private var showColors   = true
    
    private let teamNames = ["Arsenal", "Liverpool", "Man City", "None"]
    private let teamIds   = ["tm_002", "tm_003", "tm_001", ""]
    
    private let info = ComponentInfo(
        name: "Standings Table",
        description: "Displays league standings with position, team info, stats, and points in a compact table format.",
        usageScenarios: [
            UsageScenario(icon: "trophy", title: "League standings",
                          description: "Show full league classification with all stats."),
            UsageScenario(icon: "shield", title: "Team highlight",
                          description: "Highlight a specific team's position in the table.")
        ],
        configurability: "Highlight any team, position color coding (Champions League, Europa League, relegation).",
        bestPractices: [
            "Always highlight the user's favorite team.",
            "Use color coding to show qualification zones.",
            "Keep column headers short to maximize content space."
        ]
    )
    
    private let rows = [
        DSStandingRow(id: "tm_002", position: 1,  teamName: "Arsenal",    teamLogoURL: "https://media.api-sports.io/football/teams/42.png",  played: 35, won: 25, drawn: 6, lost: 4,  goalsFor: 78, goalsAgainst: 32, points: 81),
        DSStandingRow(id: "tm_003", position: 2,  teamName: "Liverpool",  teamLogoURL: "https://media.api-sports.io/football/teams/40.png",  played: 35, won: 24, drawn: 5, lost: 6,  goalsFor: 74, goalsAgainst: 35, points: 77),
        DSStandingRow(id: "tm_001", position: 3,  teamName: "Man City",   teamLogoURL: "https://media.api-sports.io/football/teams/50.png",  played: 35, won: 22, drawn: 7, lost: 6,  goalsFor: 71, goalsAgainst: 38, points: 73),
        DSStandingRow(id: "tm_007", position: 4,  teamName: "Aston Villa",teamLogoURL: "https://media.api-sports.io/football/teams/66.png",  played: 35, won: 19, drawn: 8, lost: 8,  goalsFor: 64, goalsAgainst: 45, points: 65),
        DSStandingRow(id: "tm_008", position: 5,  teamName: "Tottenham",  teamLogoURL: "https://media.api-sports.io/football/teams/47.png",  played: 35, won: 18, drawn: 6, lost: 11, goalsFor: 58, goalsAgainst: 48, points: 60),
        DSStandingRow(id: "tm_009", position: 18, teamName: "Leicester",  teamLogoURL: "https://media.api-sports.io/football/teams/46.png",  played: 35, won: 4,  drawn: 5, lost: 26, goalsFor: 29, goalsAgainst: 82, points: 17)
    ]
    
    var body: some View {
        ComponentPlaygroundView(info: info) {
            DSStandingsTable(rows: rows,
                             highlightTeamId: teamIds[highlightIdx]) { position in
                guard showColors else { return .none }
                switch position {
                    case 1...4:   return .championsLeague
                    case 5...6:   return .europaLeague
                    case 18...20: return .relegation
                    default:      return .none
                }
            }
        } controls: {
            CompactControlRow(title: "Highlight", options: teamNames, selected: $highlightIdx)
            CompactToggleRow(title: "Show zone colors", isOn: $showColors)
        }
    }
}

    // MARK: - Grid Playground
private struct GridPlayground: View {
    
    @Query private var teams: [Team]
    @State private var styleIdx     = 0
    @State private var cardStyleIdx = 0
    
    private let styleNames     = ["2 cols", "3 cols", "Adaptive", "Masonry"]
    private let cardStyleNames = ["Elevated", "Filled", "Outlined"]
    private let cardStyles: [DSCardStyle] = [.elevated, .filled, .outlined]
    
    private let info = ComponentInfo(
        name: "Grid",
        description: "Grids arrange items in rows and columns. Use fixed columns for uniform layouts or adaptive for responsive grids.",
        usageScenarios: [
            UsageScenario(icon: "square.grid.2x2", title: "Team browser",
                          description: "Browse teams or players in a visual grid layout."),
            UsageScenario(icon: "photo.on.rectangle", title: "Media gallery",
                          description: "Display images or cards in a masonry or fixed grid.")
        ],
        configurability: "3 styles (fixed, adaptive, masonry), configurable column count and spacing.",
        bestPractices: [
            "Use fixed 2-column grid for cards with equal content.",
            "Use adaptive grid for responsive layouts across device sizes.",
            "Use masonry for content with varying heights."
        ]
    )
    
    private var gridStyle: DSGridStyle {
        switch styleIdx {
            case 1: return .fixed(columns: 3)
            case 2: return .adaptive(minWidth: 100)
            case 3: return .masonry(columns: 2)
            default: return .fixed(columns: 2)
        }
    }
    
    var body: some View {
        ComponentPlaygroundView(info: info) {
            if teams.isEmpty {
                DSEmptyState(title: "No teams",
                             message: "Run the app to load data",
                             icon: "square.grid.2x2",
                             style: .compact,
                             iconColor: DSColor.accent)
            } else {
                DSGrid(items: Array(teams.prefix(styleIdx == 1 ? 9 : 6)),
                       style: gridStyle,
                       spacing: DSSpacing.sm) { team in
                    DSCard(style: cardStyles[cardStyleIdx],
                           padding: DSSpacing.sm) {
                        VStack(spacing: DSSpacing.xs) {
                            AsyncImage(url: URL(string: team.logoURL)) { image in
                                image.resizable().scaledToFit()
                            } placeholder: {
                                Circle().fill(DSColor.surface)
                            }
                            .frame(width: styleIdx == 1 ? 24 : 32,
                                   height: styleIdx == 1 ? 24 : 32)
                            
                            Text(team.name)
                                .font(.system(size: styleIdx == 1 ? 9 : 11))
                                .fontWeight(.medium)
                                .foregroundStyle(DSColor.Text.primary)
                                .multilineTextAlignment(.center)
                                .lineLimit(2)
                        }
                        .frame(maxWidth: .infinity)
                    }
                }
            }
        } controls: {
            CompactControlRow(title: "Layout",
                              options: styleNames,
                              selected: $styleIdx)
            CompactControlRow(title: "Card",
                              options: cardStyleNames,
                              selected: $cardStyleIdx)
        }
    }
}

#Preview {
    NavigationStack {
        DataShowcaseView()
    }
    .modelContainer(for: [Team.self, League.self], inMemory: true)
}
