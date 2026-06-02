import SwiftData

@MainActor
struct DatabaseContainer {
    
    static let shared: ModelContainer = {
        let schema = Schema([
            Team.self,
            Player.self,
            League.self,
            Match.self
        ])
        
        let config = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
        
        do {
            return try ModelContainer(for: schema, configurations: config)
        } catch {
            fatalError("Failed to create ModelContainer: \(error)")
        }
    }()
}
