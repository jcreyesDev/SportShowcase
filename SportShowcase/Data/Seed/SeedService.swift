import SwiftData
import Foundation

struct SeedService {
    
    // MARK: - Public
    static func seedIfNeeded(context: ModelContext) {
        print("🌱 SeedService: checking if seed needed...")
        guard !hasSeeded() else {
            print("🌱 SeedService: already seeded, skipping")
            return
        }
        print("🌱 SeedService: starting seed...")
        do {
            let leagues = try loadLeagues(context: context)
            print("🌱 Leagues loaded: \(leagues.count)")
            let teams   = try loadTeams(context: context, leagues: leagues)
            print("🌱 Teams loaded: \(teams.count)")
            let _       = try loadPlayers(context: context, teams: teams)
            let _       = try loadMatches(context: context, teams: teams)
            
            try context.save()
            markAsSeeded()
            print("🌱 SeedService: seed completed successfully")
        } catch {
            print("🌱 SeedService error: \(error)")
        }
    }
    
    // MARK: - Private helpers
    private static func hasSeeded() -> Bool {
        UserDefaults.standard.bool(forKey: "db_seeded")
    }
    
    private static func markAsSeeded() {
        UserDefaults.standard.set(true, forKey: "db_seeded")
    }
    
    // MARK: - Loaders
    private static func loadLeagues(context: ModelContext) throws -> [String: League] {
        let items: [LeagueJSON] = try decode("leagues")
        var map: [String: League] = [:]
        
        for item in items {
            let league = League(id: item.id,
                                name: item.name,
                                country: item.country,
                                logoURL: item.logoURL,
                                season: item.season)
            context.insert(league)
            map[item.id] = league
        }
        
        return map
    }
    
    private static func loadTeams(context: ModelContext, leagues: [String: League]) throws -> [String: Team] {
        let items: [TeamJSON] = try decode("teams")
        var map: [String: Team] = [:]
        
        for item in items {
            let team = Team(id: item.id,
                            name: item.name,
                            city: item.city,
                            logoURL: item.logoURL,
                            primaryColor: item.primaryColor,
                            isFavorite: item.isFavorite)
            team.league = leagues[item.leagueId]
            context.insert(team)
            map[item.id] = team
        }
        
        return map
    }
    
    private static func loadPlayers(context: ModelContext, teams: [String: Team]) throws -> [Player] {
        let items: [PlayerJSON] = try decode("players")
        var result: [Player] = []
        
        for item in items {
            let player = Player(id: item.id,
                                name: item.name,
                                position: item.position,
                                number: item.number,
                                age: item.age,
                                photoURL: item.photoURL,
                                goals: item.goals,
                                assists: item.assists,
                                matches: item.matches)
            player.team = teams[item.teamId]
            context.insert(player)
            result.append(player)
        }
        
        return result
    }
    
    private static func loadMatches(context: ModelContext, teams: [String: Team]) throws -> [Match] {
        let items: [MatchJSON] = try decode("matches")
        var result: [Match] = []
        
        let formatter = ISO8601DateFormatter()
        
        for item in items {
            let match = Match(id: item.id,
                              date: formatter.date(from: item.date) ?? Date(),
                              stadium: item.stadium,
                              round: item.round,
                              status: item.status,
                              homeScore: item.homeScore,
                              awayScore: item.awayScore)
            match.homeTeam = teams[item.homeTeamId]
            match.awayTeam = teams[item.awayTeamId]
            context.insert(match)
            result.append(match)
        }
        
        return result
    }
    
    // MARK: - JSON Decoder
    private static func decode<T: Decodable>(_ filename: String) throws -> T {
        guard let url = Bundle.main.url(forResource: filename, withExtension: "json") else {
            throw SeedError.fileNotFound(filename)
        }
        
        let data = try Data(contentsOf: url)
        
        return try JSONDecoder().decode(T.self, from: data)
    }
}

// MARK: - Errors
enum SeedError: Error {
    case fileNotFound(String)
}

// MARK: - JSON DTOs
private struct LeagueJSON: Decodable {
    let id, name, country, logoURL, season: String
}

private struct TeamJSON: Decodable {
    let id, name, city, leagueId, logoURL, primaryColor: String
    let isFavorite: Bool
}

private struct PlayerJSON: Decodable {
    let id, name, position, photoURL, teamId: String
    let number, age, goals, assists, matches: Int
}

private struct MatchJSON: Decodable {
    let id, homeTeamId, awayTeamId, date, stadium, status: String
    let homeScore, awayScore, round: Int
}
