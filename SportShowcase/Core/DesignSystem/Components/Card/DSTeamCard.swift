import SwiftUI
import SwiftData

struct DSTeamCard: View {
    
    let team: Team
    var style: DSCardStyle  = .elevated
    var isSelected: Bool    = false
    var onTap: (() -> Void)? = nil
    var onFavorite: (() -> Void)? = nil
    
    var body: some View {
        DSCard(style: style, isSelected: isSelected, onTap: onTap) {
            HStack(spacing: DSSpacing.md) {
                
                // MARK: Logo
                AsyncImage(url: URL(string: team.logoURL)) { image in
                    image
                        .resizable()
                        .scaledToFit()
                } placeholder: {
                    RoundedRectangle(cornerRadius: DSRadius.sm)
                        .fill(DSColor.surface)
                        .overlay(Image(systemName: "shield")
                            .foregroundStyle(DSColor.Text.tertiary))
                }
                .frame(width: 52, height: 52)
                
                // MARK: Info
                VStack(alignment: .leading, spacing: DSSpacing.xs) {
                    Text(team.name)
                        .font(DSFont.headline)
                        .foregroundStyle(DSColor.Text.primary)
                        .lineLimit(1)
                    
                    Text(team.city)
                        .font(DSFont.subheadline)
                        .foregroundStyle(DSColor.Text.secondary)
                        .lineLimit(1)
                    
                    if let league = team.league {
                        Text(league.name)
                            .font(DSFont.caption)
                            .foregroundStyle(DSColor.Text.tertiary)
                            .lineLimit(1)
                    }
                }
                
                Spacer()
                
                // MARK: Favorite + color accent
                VStack(alignment: .trailing, spacing: DSSpacing.sm) {
                    Button {
                        onFavorite?()
                    } label: {
                        Image(systemName: team.isFavorite ? "heart.fill" : "heart")
                            .font(.system(size: 18))
                            .foregroundStyle(team.isFavorite ? DSColor.Semantic.error : DSColor.Text.tertiary)
                            .animation(.spring(response: 0.3), value: team.isFavorite)
                    }
                    
                    Circle()
                        .fill(Color(hex: team.primaryColor))
                        .frame(width: 12, height: 12)
                }
            }
        }
    }
}

#Preview {
    let team = Team(id: "tm_004",
                    name: "Real Madrid",
                    city: "Madrid",
                    logoURL: "https://media.api-sports.io/football/teams/541.png",
                    primaryColor: "#FEBE10")
    
    VStack(spacing: DSSpacing.lg) {
        DSTeamCard(team: team, style: .elevated)
        DSTeamCard(team: team, style: .outlined)
        DSTeamCard(team: team, style: .glass)
    }
    .padding(DSSpacing.lg)
    .modelContainer(for: [Team.self, League.self], inMemory: true)
}
