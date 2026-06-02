import SwiftUI

@main
struct SportShowcaseApp: App {
    
    @State private var themeManager = ThemeManager.shared
    
    var body: some Scene {
        WindowGroup {
            Text("SportShowcase")
                .preferredColorScheme(themeManager.colorScheme)
        }
    }
}
