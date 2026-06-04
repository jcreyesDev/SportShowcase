import SwiftUI

enum DSGridStyle {
    case fixed(columns: Int)
    case adaptive(minWidth: CGFloat)
    case masonry(columns: Int)
}

struct DSGrid<Item: Identifiable, Content: View>: View {
    
    let items: [Item]
    var style: DSGridStyle          = .adaptive(minWidth: 160)
    var spacing: CGFloat            = DSSpacing.md
    var showScrollIndicator: Bool   = false
    @ViewBuilder let content: (Item) -> Content
    
    var body: some View {
        switch style {
            case .fixed(let columns):
                fixedGrid(columns: columns)
            case .adaptive(let minWidth):
                adaptiveGrid(minWidth: minWidth)
            case .masonry(let columns):
                masonryGrid(columns: columns)
        }
    }
    
    // MARK: - Fixed grid
    private func fixedGrid(columns: Int) -> some View {
        let gridColumns = Array(repeating: GridItem(.flexible(), spacing: spacing),
                                count: columns)
        return LazyVGrid(columns: gridColumns, spacing: spacing) {
            ForEach(items) { item in
                content(item)
            }
        }
    }
    
    // MARK: - Adaptive grid
    private func adaptiveGrid(minWidth: CGFloat) -> some View {
        let gridColumns = [GridItem(.adaptive(minimum: minWidth), spacing: spacing)]
        return LazyVGrid(columns: gridColumns, spacing: spacing) {
            ForEach(items) { item in
                content(item)
            }
        }
    }
    
    // MARK: - Masonry grid
    private func masonryGrid(columns: Int) -> some View {
        HStack(alignment: .top, spacing: spacing) {
            ForEach(0..<columns, id: \.self) { col in
                LazyVStack(spacing: spacing) {
                    ForEach(Array(items.enumerated())
                        .filter { $0.offset % columns == col }
                        .map { $0.element }) { item in
                            content(item)
                        }
                }
            }
        }
    }
}

#Preview {
    GridPreviewDemo()
}

// MARK: - Preview helper
private struct GridPreviewDemo: View {
    
    private struct TeamItem: Identifiable {
        let id: String
        let name: String
        let league: String
        let logoURL: String
        let color: String
        let points: Int
    }
    
    private let teams = [
        TeamItem(id: "1", name: "Real Madrid",   league: "La Liga",        logoURL: "https://media.api-sports.io/football/teams/541.png", color: "#FEBE10", points: 85),
        TeamItem(id: "2", name: "Barcelona",     league: "La Liga",        logoURL: "https://media.api-sports.io/football/teams/529.png", color: "#A50044", points: 78),
        TeamItem(id: "3", name: "Man City",      league: "Premier League", logoURL: "https://media.api-sports.io/football/teams/50.png",  color: "#6CABDD", points: 73),
        TeamItem(id: "4", name: "Bayern",        league: "Bundesliga",     logoURL: "https://media.api-sports.io/football/teams/157.png", color: "#DC052D", points: 82),
        TeamItem(id: "5", name: "Liverpool",     league: "Premier League", logoURL: "https://media.api-sports.io/football/teams/40.png",  color: "#C8102E", points: 77),
        TeamItem(id: "6", name: "Juventus",      league: "Serie A",        logoURL: "https://media.api-sports.io/football/teams/496.png", color: "#000000", points: 68)
    ]
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: DSSpacing.xl) {
                
                Text("Fixed 2 columns")
                    .font(DSFont.footnote)
                    .foregroundStyle(DSColor.Text.tertiary)
                
                DSGrid(items: teams, style: .fixed(columns: 2)) { team in
                    DSCard(style: .elevated) {
                        HStack(spacing: DSSpacing.sm) {
                            AsyncImage(url: URL(string: team.logoURL)) { image in
                                image.resizable().scaledToFit()
                            } placeholder: {
                                Circle().fill(DSColor.surface)
                            }
                            .frame(width: 36, height: 36)
                            
                            VStack(alignment: .leading, spacing: 2) {
                                Text(team.name)
                                    .font(DSFont.footnote)
                                    .fontWeight(.medium)
                                    .foregroundStyle(DSColor.Text.primary)
                                    .lineLimit(1)
                                Text(team.league)
                                    .font(.system(size: 10))
                                    .foregroundStyle(DSColor.Text.tertiary)
                                    .lineLimit(1)
                            }
                            Spacer()
                            Text("\(team.points)")
                                .font(DSFont.footnote)
                                .fontWeight(.bold)
                                .foregroundStyle(Color(hex: team.color))
                        }
                    }
                }
                
                Text("Adaptive (min 160pt)")
                    .font(DSFont.footnote)
                    .foregroundStyle(DSColor.Text.tertiary)
                
                DSGrid(items: teams, style: .adaptive(minWidth: 160)) { team in
                    DSStatCard(value: "\(team.points)",
                               label: team.name,
                               icon: "shield",
                               style: .filled,
                               accentColor: Color(hex: team.color))
                }
                
                Text("Masonry 2 columns")
                    .font(DSFont.footnote)
                    .foregroundStyle(DSColor.Text.tertiary)
                
                DSGrid(items: teams, style: .masonry(columns: 2)) { team in
                    DSCard(style: .outlined) {
                        VStack(alignment: .leading, spacing: DSSpacing.sm) {
                            AsyncImage(url: URL(string: team.logoURL)) { image in
                                image.resizable().scaledToFit()
                            } placeholder: {
                                Circle().fill(DSColor.surface)
                            }
                            .frame(width: 44, height: 44)
                            
                            Text(team.name)
                                .font(DSFont.subheadline)
                                .fontWeight(.medium)
                                .foregroundStyle(DSColor.Text.primary)
                            
                            Text(team.league)
                                .font(DSFont.caption)
                                .foregroundStyle(DSColor.Text.tertiary)
                            
                            DSBadge(title: "\(team.points) pts",
                                    style: .accent)
                        }
                    }
                }
            }
            .padding(DSSpacing.lg)
        }
    }
}
