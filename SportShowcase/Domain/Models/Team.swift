import SwiftData
import SwiftUI

@Model
final class Team {
    
    // MARK: - Properties
    var id: String
    var name: String
    var city: String
    var logoURL: String
    var primaryColor: String
    var isFavorite: Bool
    
    // MARK: - Relationships
    @Relationship(deleteRule: .cascade)
    var players: [Player]
    
    var league: League?
    
    // MARK: - Init
    init(id: String,
         name: String,
         city: String,
         logoURL: String,
         primaryColor: String = "#000000",
         isFavorite: Bool = false) {
        self.id           = id
        self.name         = name
        self.city         = city
        self.logoURL      = logoURL
        self.primaryColor = primaryColor
        self.isFavorite   = isFavorite
        self.players      = []
    }
}
