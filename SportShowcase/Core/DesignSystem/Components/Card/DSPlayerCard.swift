import SwiftUI
import SwiftData

struct DSPlayerCard: View {
    
    let player: Player
    var style: DSCardStyle   = .elevated
    var isSelected: Bool     = false
    var onTap: (() -> Void)? = nil
    
    var body: some View {
        DSCard(style: style, isSelected: isSelected, onTap: onTap) {
            HStack(spacing: DSSpacing.md) {
                
                // MARK: Photo
                AsyncImage(url: URL(string: player.photoURL)) { image in
                    image
                        .resizable()
                        .scaledToFill()
                } placeholder: {
                    Circle()
                        .fill(DSColor.surface)
                        .overlay(
                            Image(systemName: "person.fill")
                                .foregroundStyle(DSColor.Text.tertiary)
                        )
                }
                .frame(width: 56, height: 56)
                .clipShape(Circle())
                
                // MARK: Info
                VStack(alignment: .leading, spacing: DSSpacing.xs) {
                    Text(player.name)
                        .font(DSFont.headline)
                        .foregroundStyle(DSColor.Text.primary)
                        .lineLimit(1)
                    
                    HStack(spacing: DSSpacing.sm) {
                        DSBadge(title: player.position, style: .accent)
                        
                        Text("#\(player.number)")
                            .font(DSFont.footnote)
                            .foregroundStyle(DSColor.Text.secondary)
                    }
                    
                    if let team = player.team {
                        Text(team.name)
                            .font(DSFont.caption)
                            .foregroundStyle(DSColor.Text.tertiary)
                            .lineLimit(1)
                    }
                }
                
                Spacer()
                
                // MARK: Stats
                VStack(alignment: .trailing, spacing: DSSpacing.xs) {
                    statItem(value: player.goals,   icon: "soccerball",       color: DSColor.accent)
                    statItem(value: player.assists, icon: "hand.point.right", color: DSColor.secondary)
                    statItem(value: player.matches, icon: "sportscourt",      color: DSColor.Text.tertiary)
                }
            }
        }
    }
    
    // MARK: - Stat item
    private func statItem(value: Int, icon: String, color: Color) -> some View {
        HStack(spacing: 4) {
            Image(systemName: icon)
                .font(.system(size: 11))
                .foregroundStyle(color)
            Text("\(value)")
                .font(DSFont.footnote)
                .fontWeight(.medium)
                .foregroundStyle(DSColor.Text.primary)
        }
    }
}

#Preview {
    let player = Player(id: "pl_006",
                        name: "Kylian Mbappé",
                        position: "Forward",
                        number: 9,
                        age: 26,
                        photoURL: "https://media.api-sports.io/football/players/278.png",
                        goals: 31,
                        assists: 7,
                        matches: 35)
    
    VStack(spacing: DSSpacing.lg) {
        DSPlayerCard(player: player, style: .elevated)
        DSPlayerCard(player: player, style: .outlined)
        DSPlayerCard(player: player, style: .glass)
    }
    .padding(DSSpacing.lg)
    .modelContainer(for: [Player.self, Team.self], inMemory: true)
}
