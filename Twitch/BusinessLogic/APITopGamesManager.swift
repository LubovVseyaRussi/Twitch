//
//  TopGamesManager.swift
//  Twitch
//
//  Created by Lubov on 23.05.2021.
//

import Foundation

final class APITopGamesManager: APIManager {
    
    let sessionConfiguration: URLSessionConfiguration
    
    lazy var session: URLSession = {
        return URLSession(configuration: sessionConfiguration)
    }()
    
    init(sessionConfiguration: URLSessionConfiguration) {
        self.sessionConfiguration = sessionConfiguration
    }
    
    convenience init() {
        self.init(sessionConfiguration: URLSessionConfiguration.default)
    }
    
    func fetchTopGames(page: Int = 0, completion: @escaping (APIResult<TopGamesAPIResponse>) -> Void) {
        let baseURL = "https://api.twitch.tv/kraken/games/top?offset=\(page)"
        var request = URLRequest(url: URL(string: baseURL)!)
        
        request.addValue("application/vnd.twitchtv.v5+json", forHTTPHeaderField: "Accept" )
        request.addValue("qkajscsqx8yc89df2gf1hts8n3camd", forHTTPHeaderField: "Client-ID")
        
        fetch(request: request, decode: { (data) -> TopGamesAPIResponse? in
            do {
                let recipes = try JSONDecoder().decode(TopGamesAPIResponse.self, from: data)
                return recipes
            } catch let error {
                print(error)
                return nil
            }
        }, completion: completion)
    }
}

struct TopGamesAPIResponse: Codable {
    var top: [TopGames]
}
