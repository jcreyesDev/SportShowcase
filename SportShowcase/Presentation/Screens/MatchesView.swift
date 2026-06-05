import SwiftUI
import SwiftData

struct MatchesView: View {
    
    @Query private var matches: [Match]
    @State private var selectedStatus = "All"
    
    private let statuses = ["All", "upcoming", "finished"]
    
    private var filtered: [Match] {
        guard selectedStatus != "All" else { return matches }
        return matches.filter { $0.status == selectedStatus }
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: DSSpacing.md) {
                    DSSegmentedControl(selection: $selectedStatus,
                                       options: statuses,
                                       style: .pill,
                                       formatOption: { s in
                        switch s {
                            case "upcoming": return L10n.Match.upcoming
                            case "finished": return L10n.Match.finished
                            default:         return "All"
                        }
                    })
                    .padding(.horizontal, DSSpacing.lg)
                    .padding(.top, DSSpacing.md)
                    
                    if filtered.isEmpty {
                        DSEmptyState(title: "No matches found",
                                     message: "Try a different filter",
                                     icon: "sportscourt",
                                     style: .standard,
                                     iconColor: DSColor.accent)
                    } else {
                        LazyVStack(spacing: DSSpacing.sm) {
                            ForEach(filtered) { match in
                                DSMatchCard(match: match, style: .elevated)
                                    .padding(.horizontal, DSSpacing.lg)
                            }
                        }
                        .padding(.bottom, DSSpacing.lg)
                    }
                }
            }
            .navigationTitle(L10n.Matches.title)
        }
    }
}

#Preview {
    MatchesView()
        .modelContainer(for: [Match.self, Team.self, League.self], inMemory: true)
}
