import SwiftUI
import SwiftData

@main
struct SportShowcaseApp: App {
    
    @State private var themeManager = ThemeManager.shared
    private let container = DatabaseContainer.shared
    
    var body: some Scene {
        WindowGroup {
            RootView()
                .preferredColorScheme(themeManager.colorScheme)
                .onAppear {
                    SeedService.seedIfNeeded(context: container.mainContext)
                }
        }
        .modelContainer(container)
    }
}
