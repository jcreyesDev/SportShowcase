import SwiftUI
import SwiftData

struct RootView: View {
    
    @State private var router       = NavigationRouter.shared
    @State private var themeManager = ThemeManager.shared
    @Environment(\.horizontalSizeClass) private var sizeClass
    @Query private var teams: [Team]
    
    var body: some View {
        rootContent(for: sizeClass)
            .preferredColorScheme(themeManager.colorScheme)
            .onAppear {
                print("🔍 Teams in DB: \(teams.count)")
            }
    }
    
    @ViewBuilder
    private func rootContent(for sizeClass: UserInterfaceSizeClass?) -> some View {
        if sizeClass == .regular {
            NavigationSplitView {
                SidebarView(router: router)
            } detail: {
                detailView
            }
        } else {
            MainTabView(router: router)
        }
    }
    
    @ViewBuilder
    private var detailView: some View {
        switch router.selectedItem {
            case .catalog:  CatalogView()
            case .teams:    TeamsView()
            case .players:  PlayersView()
            case .matches:  MatchesView()
            case .settings: SettingsView()
            case .none:     CatalogView()
        }
    }
}

#Preview("iPhone — TabBar") {
    RootView()
        .environment(\.horizontalSizeClass, .compact)
}

#Preview("iPad — Sidebar") {
    RootView()
        .environment(\.horizontalSizeClass, .regular)
}
