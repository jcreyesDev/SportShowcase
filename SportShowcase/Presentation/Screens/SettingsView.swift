import SwiftUI

struct SettingsView: View {
    
    @State private var themeManager = ThemeManager.shared
    @State private var isDark       = false
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: DSSpacing.lg) {
                    DSList(items: [
                        DSListItem(id: "theme",
                                   title: L10n.Settings.theme,
                                   subtitle: isDark
                                   ? L10n.Settings.themeDark
                                   : L10n.Settings.themeLight,
                                   icon: isDark ? "moon.fill" : "sun.max.fill",
                                   iconColor: isDark
                                   ? DSColor.accent
                                   : DSColor.Semantic.warning,
                                   accessory: .toggle(Binding(
                                    get: { isDark },
                                    set: { val in
                                        isDark = val
                                        val ? themeManager.setDark() : themeManager.setLight()
                                    })))
                    ], header: L10n.Settings.title)
                    
                    DSList(items: [
                        DSListItem(id: "language",
                                   title: L10n.Settings.language,
                                   subtitle: "English / Español",
                                   icon: "globe",
                                   iconColor: DSColor.secondary,
                                   accessory: .chevron,
                                   onTap: {}),
                        DSListItem(id: "onboarding",
                                   title: "Replay Onboarding",
                                   icon: "play.circle",
                                   iconColor: DSColor.Semantic.success,
                                   accessory: .chevron,
                                   onTap: {
                                       DSCoachMarkManager.shared.reset(key: "playground_onboarding")
                                   })
                    ], header: "General")
                    
                    DSList(items: [
                        DSListItem(id: "version",
                                   title: "Version",
                                   subtitle: "1.0.0",
                                   icon: "info.circle",
                                   iconColor: DSColor.Text.tertiary)
                    ], header: "About")
                }
                .padding(DSSpacing.lg)
            }
            .navigationTitle(L10n.Settings.title)
        }
    }
}

#Preview {
    SettingsView()
}
