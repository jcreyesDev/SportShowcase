import SwiftUI

enum SidebarItem: String, CaseIterable, Identifiable {
    case catalog  = "catalog"
    case settings = "settings"
    
    var id: String { rawValue }
    
    var title: String {
        switch self {
            case .catalog:  return L10n.Catalog.title
            case .settings: return L10n.Settings.title
        }
    }
    
    var icon: String {
        switch self {
            case .catalog:  return "square.grid.2x2"
            case .settings: return "gearshape"
        }
    }
}

@Observable
class NavigationRouter {
    static let shared = NavigationRouter()
    var selectedItem: SidebarItem? = .catalog
    private init() {}
}
