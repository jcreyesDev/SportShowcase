import SwiftUI
import SwiftData

@main
struct SportShowcaseApp: App {
    
    @State private var themeManager = ThemeManager.shared
    
    init() {
        let context = DatabaseContainer.shared.mainContext
        SeedService.seedIfNeeded(context: context)
    }
    
    var body: some Scene {
        WindowGroup {
            RootView()
                .preferredColorScheme(themeManager.colorScheme)
        }
        .modelContainer(DatabaseContainer.shared)
    }
}
