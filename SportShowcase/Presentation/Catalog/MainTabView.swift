import SwiftUI

struct MainTabView: View {
    
    @Bindable var router: NavigationRouter
    
    var body: some View {
        TabView(selection: $router.selectedItem) {
            Tab(L10n.Catalog.title, systemImage: "square.grid.2x2", value: SidebarItem.catalog) {
                CatalogView()
            }
            Tab(L10n.Settings.title, systemImage: "gearshape", value: SidebarItem.settings) {
                SettingsView()
            }
        }
        .tint(DSColor.accent)
    }
}

#Preview {
    MainTabView(router: NavigationRouter.shared)
}
