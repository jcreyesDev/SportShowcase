import SwiftUI

struct RootView: View {
    
    @State private var router = NavigationRouter.shared
    @Environment(\.horizontalSizeClass) private var sizeClass
    
    var body: some View {
        rootContent(for: sizeClass)
    }
    
    @ViewBuilder
    private func rootContent(for sizeClass: UserInterfaceSizeClass?) -> some View {
        if sizeClass == .regular {
            NavigationSplitView {
                SidebarView(router: router)
            } detail: {
                Text(router.selectedItem?.title ?? L10n.Catalog.title)
            }
        } else {
            MainTabView(router: router)
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
