//
//  Game.swift
//  Twitch
//
//  Created by Lubov on 23.05.2021.
//

import Foundation

struct TopGames: Codable {
    
    var channels: Int
    var viewers: Int
    var game: Game
}

struct Game: Codable {
    
    var _id: Int
    var box: Box
    var name: String
}

struct Box: Codable {
    
    var medium: String
}

