import Foundation

enum L10n {
    
        // MARK: - General
    enum General {
        static let appName   = String(localized: "general.app_name")
        static let cancel    = String(localized: "general.cancel")
        static let save      = String(localized: "general.save")
        static let delete    = String(localized: "general.delete")
        static let edit      = String(localized: "general.edit")
        static let done      = String(localized: "general.done")
        static let back      = String(localized: "general.back")
        static let search    = String(localized: "general.search")
        static let loading   = String(localized: "general.loading")
        static let error     = String(localized: "general.error")
        static let retry     = String(localized: "general.retry")
    }
    
        // MARK: - Catalog
    enum Catalog {
        static let title             = String(localized: "catalog.title")
        static let searchPlaceholder = String(localized: "catalog.search_placeholder")
        static let allComponents     = String(localized: "catalog.all_components")
    }
    
        // MARK: - Components
    enum Components {
        static let buttons    = String(localized: "components.buttons")
        static let cards      = String(localized: "components.cards")
        static let lists      = String(localized: "components.lists")
        static let inputs     = String(localized: "components.inputs")
        static let navigation = String(localized: "components.navigation")
        static let feedback   = String(localized: "components.feedback")
        static let data       = String(localized: "components.data")
        static let layout     = String(localized: "components.layout")
    }
    
        // MARK: - Playground
    enum Playground {
        static let preview       = String(localized: "playground.preview")
        static let interact      = String(localized: "playground.interact")
        static let configuration = String(localized: "playground.configuration")
        static let about         = String(localized: "playground.about")
        static let whenToUse     = String(localized: "playground.when_to_use")
        static let bestPractices = String(localized: "playground.best_practices")
    }
    
        // MARK: - CoachMark
    enum CoachMark {
        static let skip                = String(localized: "coachmark.skip")
        static let next                = String(localized: "coachmark.next")
        static let gotIt               = String(localized: "coachmark.got_it")
        static let livePreviewTitle    = String(localized: "coachmark.preview.title")
        static let livePreviewMessage  = String(localized: "coachmark.preview.message")
        static let swipeTitle          = String(localized: "coachmark.swipe.title")
        static let swipeMessage        = String(localized: "coachmark.swipe.message")
        static let configTitle         = String(localized: "coachmark.config.title")
        static let configMessage       = String(localized: "coachmark.config.message")
        static let aboutTitle          = String(localized: "coachmark.about.title")
        static let aboutMessage        = String(localized: "coachmark.about.message")
    }
    
        // MARK: - Settings
    enum Settings {
        static let title            = String(localized: "settings.title")
        static let language         = String(localized: "settings.language")
        static let theme            = String(localized: "settings.theme")
        static let themeLight       = String(localized: "settings.theme_light")
        static let themeDark        = String(localized: "settings.theme_dark")
        static let themeSystem      = String(localized: "settings.theme_system")
        static let replayOnboarding = String(localized: "settings.replay_onboarding")
        static let version          = String(localized: "settings.version")
        static let about            = String(localized: "settings.about")
        static let general          = String(localized: "settings.general")
    }
    
        // MARK: - Teams
    enum Teams {
        static let title = String(localized: "teams.title")
    }
    
        // MARK: - Players
    enum Players {
        static let title = String(localized: "players.title")
    }
    
        // MARK: - Matches
    enum Matches {
        static let title = String(localized: "matches.title")
    }
    
        // MARK: - Button
    enum Button {
        static let confirmed         = String(localized: "button.confirmed")
        static let slideToConfirm    = String(localized: "button.slide_to_confirm")
        static let slideToDelete     = String(localized: "button.slide_to_delete")
        static let cannotUndo        = String(localized: "button.cannot_undo")
        static let deletePermanently = String(localized: "button.delete_permanently")
    }
    
        // MARK: - Match
    enum Match {
        static let finished = String(localized: "match.finished")
        static let upcoming = String(localized: "match.upcoming")
        static let live     = String(localized: "match.live")
    }
}
