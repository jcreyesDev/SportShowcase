import SwiftUI

struct MainTabView: View {
    
    @Bindable var router: NavigationRouter
    
    var body: some View {
        TabView(selection: $router.selectedItem) {
            ForEach(SidebarItem.allCases) { item in
                Tab(item.title, systemImage: item.icon, value: item) {
                    Text(item.title)
                }
            }
        }
        .tint(DSColor.accent)
    }
}

#Preview {
    MainTabView(router: NavigationRouter.shared)
}
