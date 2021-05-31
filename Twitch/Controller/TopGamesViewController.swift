//
//  TableViewController.swift
//  Twitch
//
//  Created by Lubov on 23.05.2021.
//

import UIKit

class TopGamesViewController: UIViewController, UITableViewDelegate {
    
    
    @IBOutlet weak var gamesTable: UITableView!
    
    
    var viewModel: TopGamesViewModel!
    var page = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel = TopGamesViewModel(apiManager: APITopGamesManager())
        viewModel.twitchTopGamesArray.bind { _ in
            DispatchQueue.main.async {
                self.gamesTable.reloadData()
            }
        }
        setupGamesTable()
    }
    
    func setupGamesTable() {
        
        gamesTable.dataSource = self
        gamesTable.delegate = self
        gamesTable.tableFooterView = UIView(frame: .zero)
        gamesTable.register(UINib(nibName: "GameCell", bundle: nil), forCellReuseIdentifier: "gamecell")
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        
        if offsetY > contentHeight - scrollView.frame.size.height && !viewModel.isLoading{
            page += 10
            viewModel.isLoading = true
            viewModel.fetchStreams(page: page)
        }
    }
}

extension TopGamesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.twitchTopGamesArray.value?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "gamecell") as! GameCell
        let games = viewModel.twitchTopGamesArray.value?[indexPath.row]
        cell.imageURL = URL(string: (games?.game.box.medium)!)
        cell.name = games?.game.name
        cell.channels = games?.channels
        cell.viewers = games?.viewers
        cell.commonInit()
        return cell
    }
}

