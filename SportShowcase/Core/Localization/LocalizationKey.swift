import Foundation

enum L10n {
    
        // MARK: - General
    enum General {
        static let appName              = String(localized: "general.app_name")
        static let cancel               = String(localized: "general.cancel")
        static let save                 = String(localized: "general.save")
        static let delete               = String(localized: "general.delete")
        static let edit                 = String(localized: "general.edit")
        static let done                 = String(localized: "general.done")
        static let back                 = String(localized: "general.back")
        static let search               = String(localized: "general.search")
        static let loading              = String(localized: "general.loading")
        static let error                = String(localized: "general.error")
        static let retry                = String(localized: "general.retry")
    }
    
        // MARK: - Catalog
    enum Catalog {
        static let title                = String(localized: "catalog.title")
        static let searchPlaceholder    = String(localized: "catalog.search_placeholder")
        static let allComponents        = String(localized: "catalog.all_components")
    }
    
        // MARK: - Components
    enum Components {
        static let buttons              = String(localized: "components.buttons")
        static let cards                = String(localized: "components.cards")
        static let lists                = String(localized: "components.lists")
        static let inputs               = String(localized: "components.inputs")
        static let navigation           = String(localized: "components.navigation")
        static let feedback             = String(localized: "components.feedback")
        static let data                 = String(localized: "components.data")
    }
    
        // MARK: - Settings
    enum Settings {
        static let title                = String(localized: "settings.title")
        static let language             = String(localized: "settings.language")
        static let theme                = String(localized: "settings.theme")
        static let themeLight           = String(localized: "settings.theme_light")
        static let themeDark            = String(localized: "settings.theme_dark")
        static let themeSystem          = String(localized: "settings.theme_system")
    }
}
