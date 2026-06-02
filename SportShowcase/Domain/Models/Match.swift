import SwiftData
import Foundation

@Model
final class Match {
    
    // MARK: - Properties
    var id: String
    var date: Date
    var stadium: String
    var round: Int
    var status: String
    var homeScore: Int
    var awayScore: Int
    
    // MARK: - Relationships
    var homeTeam: Team?
    var awayTeam: Team?
    var league: League?
    
    // MARK: - Init
    init(id: String,
         date: Date,
         stadium: String,
         round: Int,
         status: String,
         homeScore: Int = 0,
         awayScore: Int = 0) {
        self.id        = id
        self.date      = date
        self.stadium   = stadium
        self.round     = round
        self.status    = status
        self.homeScore = homeScore
        self.awayScore = awayScore
    }
}
