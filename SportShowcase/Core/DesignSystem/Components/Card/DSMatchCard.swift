import SwiftUI
import SwiftData

struct DSMatchCard: View {
    
    let match: Match
    var style: DSCardStyle   = .elevated
    var isSelected: Bool     = false
    var onTap: (() -> Void)? = nil
    
    var body: some View {
        DSCard(style: style, isSelected: isSelected, onTap: onTap) {
            VStack(spacing: DSSpacing.md) {
                
                // MARK: Header — league + round + status
                HStack {
                    if let league = match.homeTeam?.league {
                        Text(league.name)
                            .font(DSFont.caption)
                            .foregroundStyle(DSColor.Text.tertiary)
                    }
                    Spacer()
                    Text("Round \(match.round)")
                        .font(DSFont.caption)
                        .foregroundStyle(DSColor.Text.tertiary)
                    DSStatusBadge(status: match.status)
                }
                
                // MARK: Scoreboard
                HStack(alignment: .center, spacing: DSSpacing.lg) {
                    
                    // Home team
                    teamColumn(
                        name: match.homeTeam?.name ?? "TBD",
                        logoURL: match.homeTeam?.logoURL ?? ""
                    )
                    
                    // Score
                    VStack(spacing: DSSpacing.xs) {
                        if match.status == "upcoming" {
                            Text(formattedDate)
                                .font(DSFont.caption)
                                .foregroundStyle(DSColor.Text.secondary)
                            Text("VS")
                                .font(DSFont.title1)
                                .fontWeight(.bold)
                                .foregroundStyle(DSColor.Text.tertiary)
                        } else {
                            Text("\(match.homeScore) — \(match.awayScore)")
                                .font(DSFont.title1)
                                .fontWeight(.bold)
                                .foregroundStyle(DSColor.Text.primary)
                                .monospacedDigit()
                        }
                        Text(match.stadium)
                            .font(DSFont.caption)
                            .foregroundStyle(DSColor.Text.tertiary)
                            .lineLimit(1)
                    }
                    .frame(maxWidth: .infinity)
                    
                    // Away team
                    teamColumn(name: match.awayTeam?.name ?? "TBD",
                               logoURL: match.awayTeam?.logoURL ?? "")
                }
            }
        }
    }
    
    // MARK: - Team column
    private func teamColumn(name: String, logoURL: String) -> some View {
        VStack(spacing: DSSpacing.sm) {
            AsyncImage(url: URL(string: logoURL)) { image in
                image.resizable().scaledToFit()
            } placeholder: {
                RoundedRectangle(cornerRadius: DSRadius.sm)
                    .fill(DSColor.surface)
            }
            .frame(width: 44, height: 44)
            
            Text(name)
                .font(DSFont.caption)
                .fontWeight(.medium)
                .foregroundStyle(DSColor.Text.primary)
                .multilineTextAlignment(.center)
                .lineLimit(2)
                .frame(width: 80)
        }
    }
    
    // MARK: - Formatted date
    private var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMM · HH:mm"
        return formatter.string(from: match.date)
    }
}

#Preview {
    let homeTeam = Team(id: "tm_004",
                        name: "Real Madrid",
                        city: "Madrid",
                        logoURL: "https://media.api-sports.io/football/teams/541.png",
                        primaryColor: "#FEBE10")
    
    let awayTeam = Team(id: "tm_005",
                        name: "FC Barcelona",
                        city: "Barcelona",
                        logoURL: "https://media.api-sports.io/football/teams/529.png",
                        primaryColor: "#A50044")
    
    let match = Match(id: "mt_003",
                      date: Date(),
                      stadium: "Santiago Bernabeu",
                      round: 30,
                      status: "finished",
                      homeScore: 2,
                      awayScore: 1)
    
    match.homeTeam = homeTeam
    match.awayTeam = awayTeam
    
    return VStack(spacing: DSSpacing.lg) {
        DSMatchCard(match: match, style: .elevated)
        DSMatchCard(match: match, style: .glass)
    }
    .padding(DSSpacing.lg)
    .modelContainer(for: [Match.self, Team.self], inMemory: true)
}
