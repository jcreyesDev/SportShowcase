import SwiftUI
import SwiftData

struct TeamsView: View {
    
    @Query private var teams: [Team]
    @State private var searchText = ""
    
    private var filtered: [Team] {
        guard !searchText.isEmpty else { return teams }
        return teams.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: DSSpacing.md) {
                    DSSearchBar(text: $searchText)
                        .padding(.horizontal, DSSpacing.lg)
                        .padding(.top, DSSpacing.md)
                    
                    if filtered.isEmpty {
                        DSEmptyState(title: "No teams found",
                                     message: "Try a different search",
                                     icon: "shield",
                                     style: .standard,
                                     iconColor: DSColor.accent)
                    } else {
                        LazyVStack(spacing: DSSpacing.sm) {
                            ForEach(filtered) { team in
                                DSTeamCard(team: team,
                                           style: .elevated) {} onFavorite: {
                                    team.isFavorite.toggle()
                                }
                                           .padding(.horizontal, DSSpacing.lg)
                            }
                        }
                        .padding(.bottom, DSSpacing.lg)
                    }
                }
            }
            .navigationTitle(L10n.Teams.title)
        }
    }
}

#Preview {
    TeamsView()
        .modelContainer(for: [Team.self, League.self], inMemory: true)
}
