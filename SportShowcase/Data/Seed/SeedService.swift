import SwiftData
import Foundation

struct SeedService {
    
    static func seedIfNeeded(context: ModelContext) {
        guard !hasSeeded() else {
            return
        }
        do {
            let leagues  = try loadLeagues(context: context)
            let teams    = try loadTeams(context: context, leagues: leagues)
            _            = try loadPlayers(context: context, teams: teams)
            _            = try loadMatches(context: context, teams: teams)
            try context.save()
            markAsSeeded()
        } catch {
            print("🌱 SeedService error: \(error)")
        }
    }
    
        // MARK: - Leagues
    private static func loadLeagues(context: ModelContext) throws -> [League] {
        let footballLeagues  = try load([LeagueDTO].self, from: "leagues")
        let basketballLeagues = try load([LeagueDTO].self, from: "basketball_league")
        let tennisLeagues    = try load([LeagueDTO].self, from: "tennis_league")
        
        let allDTOs = footballLeagues + basketballLeagues + tennisLeagues
        return allDTOs.map { dto in
            let league = League(id: dto.id,
                                name: dto.name,
                                country: dto.country,
                                logoURL: dto.logoURL,
                                season: dto.season)
            context.insert(league)
            return league
        }
    }
    
        // MARK: - Teams
    private static func loadTeams(context: ModelContext,
                                  leagues: [League]) throws -> [Team] {
        let footballTeams    = try load([TeamDTO].self, from: "teams")
        let basketballTeams  = try load([TeamDTO].self, from: "basketball_teams")
        let tennisTeams      = try load([TeamDTO].self, from: "tennis_teams")
        
        let allDTOs = footballTeams + basketballTeams + tennisTeams
        return allDTOs.compactMap { dto in
            let team = Team(id: dto.id,
                            name: dto.name,
                            city: dto.city,
                            logoURL: dto.logoURL,
                            primaryColor: dto.primaryColor)
            team.league = leagues.first { $0.id == dto.leagueId }
            context.insert(team)
            return team
        }
    }
    
        // MARK: - Players
    private static func loadPlayers(context: ModelContext,
                                    teams: [Team]) throws -> [Player] {
        let footballPlayers   = try load([PlayerDTO].self, from: "players")
        let basketballPlayers = try load([PlayerDTO].self, from: "basketball_players")
        let tennisPlayers     = try load([PlayerDTO].self, from: "tennis_players")
        
        let allDTOs = footballPlayers + basketballPlayers + tennisPlayers
        return allDTOs.compactMap { dto in
            let player = Player(id: dto.id,
                                name: dto.name,
                                position: dto.position,
                                number: dto.number,
                                age: dto.age,
                                photoURL: dto.photoURL,
                                goals: dto.goals,
                                assists: dto.assists,
                                matches: dto.matches)
            player.team = teams.first { $0.id == dto.teamId }
            context.insert(player)
            return player
        }
    }
    
        // MARK: - Matches
    private static func loadMatches(context: ModelContext,
                                    teams: [Team]) throws -> [Match] {
        let footballMatches   = try load([MatchDTO].self, from: "matches")
        let basketballMatches = try load([MatchDTO].self, from: "basketball_matches")
        let tennisMatches     = try load([MatchDTO].self, from: "tennis_matches")
        
        let allDTOs = footballMatches + basketballMatches + tennisMatches
        return allDTOs.compactMap { dto in
            let match = Match(id: dto.id,
                              date: dto.parsedDate,
                              stadium: dto.stadium,
                              round: dto.round,
                              status: dto.status,
                              homeScore: dto.homeScore,
                              awayScore: dto.awayScore)
            match.homeTeam = teams.first { $0.id == dto.homeTeamId }
            match.awayTeam = teams.first { $0.id == dto.awayTeamId }
            context.insert(match)
            return match
        }
    }
    
        // MARK: - Generic loader
    private static func load<T: Decodable>(_ type: T.Type,
                                           from filename: String) throws -> T {
        guard let url = Bundle.main.url(forResource: filename,
                                        withExtension: "json") else {
            throw SeedError.fileNotFound(filename)
        }
        let data = try Data(contentsOf: url)
        return try JSONDecoder().decode(type, from: data)
    }
    
        // MARK: - Persistence
    private static func hasSeeded() -> Bool {
        UserDefaults.standard.bool(forKey: "db_seeded")
    }
    
    private static func markAsSeeded() {
        UserDefaults.standard.set(true, forKey: "db_seeded")
    }
    
    enum SeedError: Error {
        case fileNotFound(String)
    }
}

    // MARK: - DTOs
private struct LeagueDTO: Decodable {
    let id, name, country, logoURL, season: String
}

private struct TeamDTO: Decodable {
    let id, name, city, logoURL, primaryColor, leagueId: String
}

private struct PlayerDTO: Decodable {
    let id, name, position: String
    let number, age: Int
    let teamId, photoURL: String
    let goals, assists, matches: Int
}

private struct MatchDTO: Decodable {
    let id, homeTeamId, awayTeamId: String
    let date, stadium, status: String
    let round, homeScore, awayScore: Int
    
    var parsedDate: Date {
        let formatter = ISO8601DateFormatter()
        return formatter.date(from: date) ?? Date()
    }
}
