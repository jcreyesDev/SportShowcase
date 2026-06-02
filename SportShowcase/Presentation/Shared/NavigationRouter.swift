import SwiftUI

enum SidebarItem: String, CaseIterable, Identifiable {
    case catalog  = "catalog"
    case teams    = "teams"
    case players  = "players"
    case matches  = "matches"
    case settings = "settings"
    
    var id: String { rawValue }
    
    var title: String {
        switch self {
            case .catalog:  return L10n.Catalog.title
            case .teams:    return L10n.Teams.title
            case .players:  return L10n.Players.title
            case .matches:  return L10n.Matches.title
            case .settings: return L10n.Settings.title
        }
    }
    
    var icon: String {
        switch self {
            case .catalog:  return "square.grid.2x2"
            case .teams:    return "shield"
            case .players:  return "person.2"
            case .matches:  return "sportscourt"
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
