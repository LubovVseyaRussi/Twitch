//
//  TopGamesViewModel.swift
//  Twitch
//
//  Created by Lubov on 23.05.2021.
//

import Foundation

class TopGamesViewModel {
    
    var twitchTopGamesArray: Boxing<[TopGames]?> = Boxing(nil)
    var twitchTopGamesManager: APITopGamesManager
    var twitchTopGamesDataManager = TopGamesDataManager()
    var isLoading: Bool = true
    
    func fetchStreams(page: Int = 0) {
        
        twitchTopGamesManager.fetchTopGames(page: page) { [weak self] result in
            switch result {
            case .Success(let response):
                self?.twitchTopGamesArray.value?.append(contentsOf: response.top)
                print(response.top)
            case .Failure(let error):
                print(error)
            }
            self?.isLoading = false
        }
    }
    
    init(apiManager: APITopGamesManager) {
        twitchTopGamesArray.value = []
        twitchTopGamesManager = apiManager
        DispatchQueue.global().async {
            self.fetchStreams()
        }
    }
}
