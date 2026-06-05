import SwiftUI
import SwiftData

struct CardShowcaseView: View {
    
    @State private var currentPage = 0
    
    private struct CardComponent: Identifiable {
        let id: Int
        let name: String
    }
    
    private let components = [
        CardComponent(id: 0, name: "Team Card"),
        CardComponent(id: 1, name: "Player Card"),
        CardComponent(id: 2, name: "Match Card"),
        CardComponent(id: 3, name: "Stat Card"),
        CardComponent(id: 4, name: "Base Card")
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
        .navigationTitle("Cards")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    @ViewBuilder
    private func playgroundContent(for index: Int) -> some View {
        switch index {
            case 0: TeamCardPlayground()
            case 1: PlayerCardPlayground()
            case 2: MatchCardPlayground()
            case 3: StatCardPlayground()
            case 4: BaseCardPlayground()
            default: EmptyView()
        }
    }
}

    // MARK: - Team Card Playground
private struct TeamCardPlayground: View {
    
    @Query private var teams: [Team]
    @State private var styleIdx    = 0
    @State private var isSelected  = false
    @State private var toast: DSToastData?
    
    private let styles: [DSCardStyle] = [.elevated, .filled, .outlined, .glass]
    private let styleNames = ["Elevated", "Filled", "Outlined", "Glass"]
    
    private let info = ComponentInfo(
        name: "Team Card",
        description: "Displays team information including logo, name, city, league, and favorite status.",
        usageScenarios: [
            UsageScenario(icon: "shield", title: "Team lists",
                          description: "Browse and select teams from a league or search results."),
            UsageScenario(icon: "heart", title: "Favorites",
                          description: "Show favorite teams with a persistent toggle.")
        ],
        configurability: "4 card styles, selectable state, favorite toggle.",
        bestPractices: [
            "Use elevated style for primary team lists.",
            "Show selection state when cards are tappable.",
            "Persist favorite state with SwiftData."
        ]
    )
    
    var body: some View {
        ComponentPlaygroundView(info: info) {
            if let team = teams.first {
                DSTeamCard(team: team,
                           style: styles[styleIdx],
                           isSelected: isSelected) {
                    withAnimation { isSelected.toggle() }
                } onFavorite: {
                    team.isFavorite.toggle()
                    toast = DSToastData(message: team.isFavorite
                                        ? "\(team.name) added"
                                        : "\(team.name) removed",
                                        type: team.isFavorite ? .success : .info)
                }
            } else {
                DSEmptyState(title: "No teams",
                             message: "Run the app to load data",
                             icon: "shield",
                             style: .compact,
                             iconColor: DSColor.accent)
            }
        } controls: {
            CompactControlRow(title: "Style", options: styleNames, selected: $styleIdx)
            CompactToggleRow(title: "Selected", isOn: $isSelected)
        }
        .dsToast($toast)
    }
}

    // MARK: - Player Card Playground
private struct PlayerCardPlayground: View {
    
    @Query private var players: [Player]
    @State private var styleIdx = 0
    
    private let styles: [DSCardStyle] = [.elevated, .filled, .outlined, .glass]
    private let styleNames = ["Elevated", "Filled", "Outlined", "Glass"]
    
    private let info = ComponentInfo(
        name: "Player Card",
        description: "Displays player information including photo, name, position, number, team, and stats.",
        usageScenarios: [
            UsageScenario(icon: "person.2", title: "Player lists",
                          description: "Browse players by team or position with key stats visible."),
            UsageScenario(icon: "chart.bar", title: "Stats overview",
                          description: "Quick view of goals, assists, and matches at a glance.")
        ],
        configurability: "4 card styles, selectable state.",
        bestPractices: [
            "Show the most relevant stats for the context.",
            "Use position badge to help users scan quickly.",
            "Load player photos asynchronously with a placeholder."
        ]
    )
    
    var body: some View {
        ComponentPlaygroundView(info: info) {
            if let player = players.first {
                DSPlayerCard(player: player,
                             style: styles[styleIdx])
            } else {
                DSEmptyState(title: "No players",
                             message: "Run the app to load data",
                             icon: "person.2",
                             style: .compact,
                             iconColor: DSColor.secondary)
            }
        } controls: {
            CompactControlRow(title: "Style", options: styleNames, selected: $styleIdx)
        }
    }
}

    // MARK: - Match Card Playground
private struct MatchCardPlayground: View {
    
    @Query private var matches: [Match]
    @State private var styleIdx   = 0
    @State private var matchIdx   = 0
    
    private let styles: [DSCardStyle] = [.elevated, .filled, .outlined, .glass]
    private let styleNames = ["Elevated", "Filled", "Outlined", "Glass"]
    
    private let info = ComponentInfo(
        name: "Match Card",
        description: "Displays match information including teams, score, date, stadium, and status.",
        usageScenarios: [
            UsageScenario(icon: "sportscourt", title: "Match lists",
                          description: "Browse upcoming and finished matches by round."),
            UsageScenario(icon: "clock", title: "Live scores",
                          description: "Show live match progress with real-time score updates.")
        ],
        configurability: "4 card styles, supports upcoming and finished match states.",
        bestPractices: [
            "Differentiate upcoming vs finished matches visually.",
            "Show VS for upcoming matches instead of a score.",
            "Use status badge to communicate match state clearly."
        ]
    )
    
    var body: some View {
        ComponentPlaygroundView(info: info) {
            if !matches.isEmpty {
                DSMatchCard(match: matches[min(matchIdx, matches.count - 1)],
                            style: styles[styleIdx])
            } else {
                DSEmptyState(title: "No matches",
                             message: "Run the app to load data",
                             icon: "sportscourt",
                             style: .compact,
                             iconColor: DSColor.accent)
            }
        } controls: {
            CompactControlRow(title: "Style", options: styleNames, selected: $styleIdx)
            if matches.count > 1 {
                CompactControlRow(title: "Match",
                                  options: matches.prefix(4).map { $0.homeTeam?.name ?? "Match" },
                                  selected: $matchIdx)
            }
        }
    }
}

    // MARK: - Stat Card Playground
private struct StatCardPlayground: View {
    
    @State private var styleIdx  = 0
    @State private var colorIdx  = 0
    @State private var trendIdx  = 0
    
    private let styles: [DSCardStyle] = [.elevated, .filled, .outlined, .glass]
    private let styleNames = ["Elevated", "Filled", "Outlined", "Glass"]
    private let colors: [Color] = [DSColor.accent, DSColor.secondary,
                                   DSColor.Semantic.success, DSColor.Semantic.error]
    private let colorNames = ["Accent", "Secondary", "Success", "Error"]
    private let trendNames = ["Up", "Down", "Neutral", "None"]
    
    private let info = ComponentInfo(
        name: "Stat Card",
        description: "Highlights a single key metric with a large value, label, icon, and optional trend indicator.",
        usageScenarios: [
            UsageScenario(icon: "chart.bar", title: "Key metrics",
                          description: "Show goals, assists, matches, or any KPI at a glance."),
            UsageScenario(icon: "arrow.up.right", title: "Trend display",
                          description: "Show positive or negative trends compared to previous period.")
        ],
        configurability: "4 styles, custom icon, accent color, and trend badge.",
        bestPractices: [
            "Use in grids of 2-4 for dashboard-style layouts.",
            "Keep the value short — 3-4 characters maximum.",
            "Use trend colors consistently: green for positive, red for negative."
        ]
    )
    
    private var trend: DSTrend? {
        switch trendIdx {
            case 0: return .up("+4")
            case 1: return .down("-2")
            case 2: return .neutral("0")
            default: return nil
        }
    }
    
    var body: some View {
        ComponentPlaygroundView(info: info) {
            DSStatCard(value: "31",
                       label: "Goals scored",
                       icon: "soccerball",
                       style: styles[styleIdx],
                       accentColor: colors[colorIdx],
                       trend: trend)
            .frame(maxWidth: 200)
        } controls: {
            CompactControlRow(title: "Style", options: styleNames, selected: $styleIdx)
            CompactControlRow(title: "Color", options: colorNames, selected: $colorIdx)
            CompactControlRow(title: "Trend", options: trendNames, selected: $trendIdx)
        }
    }
}

    // MARK: - Base Card Playground
private struct BaseCardPlayground: View {
    
    @State private var styleIdx      = 0
    @State private var isSelected    = false
    @State private var isExpandable  = false
    @State private var paddingIdx    = 1
    
    private let styles: [DSCardStyle] = [.elevated, .filled, .outlined, .glass]
    private let styleNames = ["Elevated", "Filled", "Outlined", "Glass"]
    private let paddingNames = ["Small", "Medium", "Large"]
    private let paddingValues: [CGFloat] = [DSSpacing.sm, DSSpacing.lg, DSSpacing.xl]
    
    private let info = ComponentInfo(
        name: "Base Card",
        description: "A generic container surface for grouping related content. Fully configurable and accepts any content.",
        usageScenarios: [
            UsageScenario(icon: "rectangle.stack", title: "Content grouping",
                          description: "Wrap any content in a card surface for visual grouping."),
            UsageScenario(icon: "chevron.down", title: "Expandable content",
                          description: "Use expandable mode for progressive disclosure of details.")
        ],
        configurability: "4 styles, selectable state, expandable mode, configurable padding and corner radius.",
        bestPractices: [
            "Use elevated for primary content, outlined for secondary.",
            "Keep card content scannable — avoid too much text.",
            "Use glass style on colorful backgrounds only."
        ]
    )
    
    var body: some View {
        ComponentPlaygroundView(info: info) {
            DSCard(style: styles[styleIdx],
                   padding: paddingValues[paddingIdx],
                   isSelected: isSelected,
                   isExpandable: isExpandable) {
                HStack(spacing: DSSpacing.md) {
                    Image(systemName: "sportscourt")
                        .font(.system(size: 20))
                        .foregroundStyle(DSColor.accent)
                    VStack(alignment: .leading, spacing: 2) {
                        Text("Card content")
                            .font(DSFont.subheadline)
                            .fontWeight(.medium)
                            .foregroundStyle(DSColor.Text.primary)
                        Text("Tap to select · Swipe controls")
                            .font(DSFont.caption)
                            .foregroundStyle(DSColor.Text.tertiary)
                    }
                }
            }
        } controls: {
            CompactControlRow(title: "Style", options: styleNames, selected: $styleIdx)
            CompactControlRow(title: "Padding", options: paddingNames, selected: $paddingIdx)
            CompactToggleRow(title: "Selected", isOn: $isSelected)
            CompactToggleRow(title: "Expandable", isOn: $isExpandable)
        }
    }
}

#Preview {
    NavigationStack {
        CardShowcaseView()
    }
    .modelContainer(for: [Team.self, Player.self, Match.self, League.self],
                    inMemory: true)
}
