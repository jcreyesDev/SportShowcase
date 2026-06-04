import SwiftUI

// MARK: - Standing row model
struct DSStandingRow: Identifiable {
    let id: String
    let position: Int
    let teamName: String
    let teamLogoURL: String
    let played: Int
    let won: Int
    let drawn: Int
    let lost: Int
    let goalsFor: Int
    let goalsAgainst: Int
    let points: Int
    
    var goalDiff: Int { goalsFor - goalsAgainst }
    var goalDiffText: String { goalDiff > 0 ? "+\(goalDiff)" : "\(goalDiff)" }
    var goalsText: String { "\(goalsFor):\(goalsAgainst)" }
}

enum DSStandingPosition {
    case championsLeague
    case europaLeague
    case conferenceLeague
    case relegation
    case none
    
    var color: Color {
        switch self {
            case .championsLeague:   return DSColor.Semantic.success
            case .europaLeague:      return DSColor.accent
            case .conferenceLeague:  return DSColor.Semantic.warning
            case .relegation:        return DSColor.Semantic.error
            case .none:              return Color.clear
        }
    }
}

// MARK: - Main component
struct DSStandingsTable: View {
    
    let rows: [DSStandingRow]
    var title: String?                              = nil
    var highlightTeamId: String?                    = nil
    var positionColor: ((Int) -> DSStandingPosition) = { _ in .none }
    var onRowTap: ((DSStandingRow) -> Void)?        = nil
    
    var body: some View {
        VStack(spacing: 0) {
            if let title {
                HStack {
                    Text(title)
                        .font(DSFont.footnote)
                        .fontWeight(.medium)
                        .foregroundStyle(DSColor.Text.secondary)
                    Spacer()
                }
                .padding(.horizontal, DSSpacing.md)
                .padding(.vertical, DSSpacing.sm)
                .background(DSColor.Background.secondary)
            }
            
            // Header
            headerRow
            
            DSDivider()
            
            // Rows
            ForEach(Array(rows.enumerated()), id: \.element.id) { index, row in
                standingRow(row: row, index: index)
                if index < rows.count - 1 {
                    DSDivider()
                        .padding(.leading, 44)
                }
            }
        }
        .background(DSColor.Background.card)
        .clipShape(RoundedRectangle(cornerRadius: DSRadius.lg))
        .overlay(RoundedRectangle(cornerRadius: DSRadius.lg)
            .strokeBorder(DSColor.Text.tertiary.opacity(0.15), lineWidth: 0.5))
    }
    
    // MARK: - Header row
    private var headerRow: some View {
        HStack(spacing: 0) {
            // Position + Team
            HStack {
                Text("#")
                    .frame(width: 28, alignment: .center)
                Text("Team")
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding(.leading, DSSpacing.sm)
            
            // Stats
            Group {
                Text("J").frame(width: 24, alignment: .center)
                Text("V").frame(width: 24, alignment: .center)
                Text("E").frame(width: 24, alignment: .center)
                Text("P").frame(width: 24, alignment: .center)
                Text("GD").frame(width: 32, alignment: .center)
                Text("Pts").frame(width: 32, alignment: .center)
            }
            .padding(.trailing, 2)
        }
        .font(.system(size: 10, weight: .medium))
        .foregroundStyle(DSColor.Text.tertiary)
        .padding(.vertical, DSSpacing.sm)
        .padding(.horizontal, DSSpacing.sm)
        .background(DSColor.Background.secondary)
    }
    
    // MARK: - Standing row
    private func standingRow(row: DSStandingRow, index: Int) -> some View {
        let isHighlighted = highlightTeamId == row.id
        let posStyle = positionColor(row.position)
        
        return Button {
            onRowTap?(row)
        } label: {
            HStack(spacing: 0) {
                // Position indicator + number
                HStack(spacing: 4) {
                    Rectangle()
                        .fill(posStyle.color)
                        .frame(width: 3)
                        .clipShape(RoundedRectangle(cornerRadius: 2))
                    
                    Text("\(row.position)")
                        .font(.system(size: 11, weight: isHighlighted ? .bold : .medium))
                        .foregroundStyle(isHighlighted ? DSColor.accent : DSColor.Text.secondary)
                        .frame(width: 22, alignment: .center)
                }
                .frame(width: 28)
                
                // Logo + name
                HStack(spacing: DSSpacing.sm) {
                    AsyncImage(url: URL(string: row.teamLogoURL)) { image in
                        image.resizable().scaledToFit()
                    } placeholder: {
                        Circle().fill(DSColor.surface)
                    }
                    .frame(width: 20, height: 20)
                    
                    Text(row.teamName)
                        .font(.system(size: 12, weight: isHighlighted ? .semibold : .regular))
                        .foregroundStyle(isHighlighted ? DSColor.accent : DSColor.Text.primary)
                        .lineLimit(1)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                .padding(.leading, DSSpacing.xs)
                
                // Stats
                Group {
                    Text("\(row.played)").frame(width: 24, alignment: .center)
                    Text("\(row.won)").frame(width: 24, alignment: .center)
                    Text("\(row.drawn)").frame(width: 24, alignment: .center)
                    Text("\(row.lost)").frame(width: 24, alignment: .center)
                    Text(row.goalDiffText)
                        .foregroundStyle(row.goalDiff > 0
                                         ? DSColor.Semantic.success
                                         : row.goalDiff < 0
                                         ? DSColor.Semantic.error
                                         : DSColor.Text.secondary)
                        .frame(width: 32, alignment: .center)
                    Text("\(row.points)")
                        .fontWeight(.semibold)
                        .foregroundStyle(isHighlighted ? DSColor.accent : DSColor.Text.primary)
                        .frame(width: 32, alignment: .center)
                }
                .font(.system(size: 11))
                .foregroundStyle(DSColor.Text.secondary)
                .padding(.trailing, 2)
            }
            .padding(.vertical, 8)
            .padding(.horizontal, DSSpacing.sm)
            .background(isHighlighted
                        ? DSColor.accent.opacity(0.06)
                        : index % 2 != 0
                        ? DSColor.Background.secondary.opacity(0.4)
                        : Color.clear)
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    let rows = [
        DSStandingRow(id: "tm_002", position: 1,  teamName: "Arsenal",       teamLogoURL: "https://media.api-sports.io/football/teams/42.png",  played: 35, won: 25, drawn: 6,  lost: 4,  goalsFor: 78, goalsAgainst: 32, points: 81),
        DSStandingRow(id: "tm_003", position: 2,  teamName: "Liverpool",      teamLogoURL: "https://media.api-sports.io/football/teams/40.png",  played: 35, won: 24, drawn: 5,  lost: 6,  goalsFor: 74, goalsAgainst: 35, points: 77),
        DSStandingRow(id: "tm_001", position: 3,  teamName: "Man City",       teamLogoURL: "https://media.api-sports.io/football/teams/50.png",  played: 35, won: 22, drawn: 7,  lost: 6,  goalsFor: 71, goalsAgainst: 38, points: 73),
        DSStandingRow(id: "tm_007", position: 4,  teamName: "Aston Villa",    teamLogoURL: "https://media.api-sports.io/football/teams/66.png",  played: 35, won: 19, drawn: 8,  lost: 8,  goalsFor: 64, goalsAgainst: 45, points: 65),
        DSStandingRow(id: "tm_008", position: 5,  teamName: "Tottenham",      teamLogoURL: "https://media.api-sports.io/football/teams/47.png",  played: 35, won: 18, drawn: 6,  lost: 11, goalsFor: 58, goalsAgainst: 48, points: 60),
        DSStandingRow(id: "tm_009", position: 6,  teamName: "Chelsea",        teamLogoURL: "https://media.api-sports.io/football/teams/49.png",  played: 35, won: 16, drawn: 9,  lost: 10, goalsFor: 61, goalsAgainst: 52, points: 57),
        DSStandingRow(id: "tm_010", position: 7,  teamName: "Newcastle",      teamLogoURL: "https://media.api-sports.io/football/teams/34.png",  played: 35, won: 15, drawn: 8,  lost: 12, goalsFor: 54, goalsAgainst: 49, points: 53),
        DSStandingRow(id: "tm_011", position: 18, teamName: "Brentford",      teamLogoURL: "https://media.api-sports.io/football/teams/55.png",  played: 35, won: 8,  drawn: 6,  lost: 21, goalsFor: 38, goalsAgainst: 68, points: 30),
        DSStandingRow(id: "tm_012", position: 19, teamName: "Southampton",    teamLogoURL: "https://media.api-sports.io/football/teams/41.png",  played: 35, won: 5,  drawn: 4,  lost: 26, goalsFor: 27, goalsAgainst: 79, points: 19),
        DSStandingRow(id: "tm_013", position: 20, teamName: "Leicester",      teamLogoURL: "https://media.api-sports.io/football/teams/46.png",  played: 35, won: 4,  drawn: 5,  lost: 26, goalsFor: 29, goalsAgainst: 82, points: 17)
    ]
    
    ScrollView {
        VStack(spacing: DSSpacing.lg) {
            DSStandingsTable(rows: rows,
                             title: "Premier League 2024/25",
                             highlightTeamId: "tm_001") { position in
                switch position {
                    case 1...4:  return .championsLeague
                    case 5...6:  return .europaLeague
                    case 7:      return .conferenceLeague
                    case 18...20: return .relegation
                    default:     return .none
                }
            } onRowTap: { row in
                print("Tapped: \(row.teamName)")
            }
        }
        .padding(DSSpacing.lg)
    }
}
