import SwiftUI
import SwiftData

@main
struct SportShowcaseApp: App {
    
    @State private var themeManager = ThemeManager.shared
    
    var body: some Scene {
        WindowGroup {
            Text("SportShowcase")
                .preferredColorScheme(themeManager.colorScheme)
        }
        .modelContainer(DatabaseContainer.shared)
    }
}
