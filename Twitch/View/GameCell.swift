//
//  GameCell.swift
//  Twitch
//
//  Created by Lubov on 23.05.2021.
//

import UIKit
import Kingfisher

class GameCell: UITableViewCell {
    
    @IBOutlet weak var gameImage: UIImageView!
    @IBOutlet weak var gameName: UILabel!
    @IBOutlet weak var gameChannels: UILabel!
    @IBOutlet weak var gameViewers: UILabel!
    
    var imageURL: URL?
    var name: String?
    var channels: Int?
    var viewers: Int?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func commonInit() {
        gameName.text = name
        gameChannels.text = "channels: \(channels ?? 0)"
        gameViewers.text = "viewers: \(viewers ?? 0)"
        gameImage.kf.indicatorType = .activity
        gameImage.kf.setImage(with: imageURL)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
