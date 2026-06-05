import SwiftUI
import SwiftData

struct PlayersView: View {
    
    @Query private var players: [Player]
    @State private var searchText = ""
    
    private var filtered: [Player] {
        guard !searchText.isEmpty else { return players }
        return players.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: DSSpacing.md) {
                    DSSearchBar(text: $searchText)
                        .padding(.horizontal, DSSpacing.lg)
                        .padding(.top, DSSpacing.md)
                    
                    if filtered.isEmpty {
                        DSEmptyState(title: "No players found",
                                     message: "Try a different search",
                                     icon: "person.2",
                                     style: .standard,
                                     iconColor: DSColor.secondary)
                    } else {
                        LazyVStack(spacing: DSSpacing.sm) {
                            ForEach(filtered) { player in
                                DSPlayerCard(player: player, style: .elevated)
                                    .padding(.horizontal, DSSpacing.lg)
                            }
                        }
                        .padding(.bottom, DSSpacing.lg)
                    }
                }
            }
            .navigationTitle(L10n.Players.title)
        }
    }
}

#Preview {
    PlayersView()
        .modelContainer(for: [Player.self, Team.self], inMemory: true)
}
