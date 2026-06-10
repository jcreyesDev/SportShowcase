import SwiftUI

struct SettingsView: View {
    
    private var themeManager: ThemeManager { ThemeManager.shared }
    @State private var isDark = false
    
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
                                   onTap: {
                                       if let url = URL(string: UIApplication.openSettingsURLString) {
                                           UIApplication.shared.open(url)
                                       }
                                   }),
                        DSListItem(id: "onboarding",
                                   title: L10n.Settings.replayOnboarding,
                                   icon: "play.circle",
                                   iconColor: DSColor.Semantic.success,
                                   accessory: .chevron,
                                   onTap: {
                                       DSCoachMarkManager.shared.reset(key: "playground_onboarding")
                                   })
                    ], header: L10n.Settings.general)
                    
                    DSList(items: [
                        DSListItem(id: "version",
                                   title: L10n.Settings.version,
                                   subtitle: "1.0.0",
                                   icon: "info.circle",
                                   iconColor: DSColor.Text.tertiary)
                    ], header: L10n.Settings.about)
                }
                .padding(DSSpacing.lg)
            }
            .navigationTitle(L10n.Settings.title)
            .onAppear {
                isDark = themeManager.colorScheme == .dark
            }
        }
    }
}

#Preview {
    SettingsView()
}
