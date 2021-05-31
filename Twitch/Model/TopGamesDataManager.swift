//
//  TopGamesDataManager.swift
//  Twitch
//
//  Created by Lubov on 23.05.2021.
//

import Foundation
import CoreData

class TopGamesDataManager {
    
    private var context : NSManagedObjectContext!
    private var gamesEntities = [TopGamesEntity]()
    
    private func fetchGames(predicate: NSPredicate?) {
        context = CoreDataStack().persistentContainer.viewContext
        let request : NSFetchRequest<TopGamesEntity> = TopGamesEntity.fetchRequest()
        if predicate != nil {
            request.predicate = predicate
        }
        do {
            let results = try context.fetch(request)
            gamesEntities = results
        } catch {
            print(error)
        }
    }
    
    func toTopGames() -> [TopGames] {
        var games = [TopGames]()
        fetchGames(predicate: nil)
        guard gamesEntities.count != 0 else { return games}
        for gamesEntity in gamesEntities {
            games.append(toTopGames(gamesEntity))
        }
        return games
    }
    
    func toTopGames(_ gamesEntity: TopGamesEntity) -> TopGames {
        let games = TopGames(channels: Int(gamesEntity.channels), viewers: Int(gamesEntity.viewers), game: Game(_id: Int(gamesEntity.id), box: Box(medium: gamesEntity.imageURL!), name: gamesEntity.name!))
        return games
    }
    
    func saveGames(games: TopGames) -> Bool {
        context = CoreDataStack().persistentContainer.viewContext
        let savingGames = TopGamesEntity(context: context)
        var success = false
        savingGames.id = Int32(games.game._id)
        savingGames.name = games.game.name
        savingGames.channels = Int32(games.channels)
        savingGames.viewers = Int32(games.viewers)
        savingGames.imageURL = games.game.box.medium
        
        do {
            try self.context.save()
            success = true
        } catch {
            print(error)
            success = false
        }
        return success
    }
}
