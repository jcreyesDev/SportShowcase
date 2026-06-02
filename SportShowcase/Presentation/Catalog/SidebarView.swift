import SwiftUI

struct SidebarView: View {
    
    @Bindable var router: NavigationRouter
    
    var body: some View {
        List(SidebarItem.allCases, selection: $router.selectedItem) { item in
            Label(item.title, systemImage: item.icon)
                .tag(item)
        }
        .navigationTitle(L10n.General.appName)
        .listStyle(.sidebar)
    }
}

#Preview {
    NavigationStack {
        SidebarView(router: NavigationRouter.shared)
    }
}
