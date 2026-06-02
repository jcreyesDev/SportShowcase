import SwiftData

@Model
final class Player {
    
    // MARK: - Properties
    var id: String
    var name: String
    var position: String
    var number: Int
    var age: Int
    var photoURL: String
    var goals: Int
    var assists: Int
    var matches: Int
    
    // MARK: - Relationships
    var team: Team?
    
    // MARK: - Init
    init(id: String,
         name: String,
         position: String,
         number: Int,
         age: Int,
         photoURL: String,
         goals: Int = 0,
         assists: Int = 0,
         matches: Int = 0) {
        self.id       = id
        self.name     = name
        self.position = position
        self.number   = number
        self.age      = age
        self.photoURL = photoURL
        self.goals    = goals
        self.assists  = assists
        self.matches  = matches
    }
}
