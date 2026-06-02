import SwiftData

@Model
final class League {
    
    // MARK: - Properties
    var id: String
    var name: String
    var country: String
    var logoURL: String
    var season: String
    
    // MARK: - Relationships
    @Relationship(deleteRule: .cascade)
    var teams: [Team]
    
    // MARK: - Init
    init(id: String,
         name: String,
         country: String,
         logoURL: String,
         season: String) {
        self.id      = id
        self.name    = name
        self.country = country
        self.logoURL = logoURL
        self.season  = season
        self.teams   = []
    }
}
