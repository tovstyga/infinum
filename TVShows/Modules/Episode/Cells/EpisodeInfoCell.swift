//
//  EpisodeInfoCell.swift
//  TVShows
//
//  Created by Aliaksandr Taustyha on 11/6/18.
//  Copyright © 2018 Aliaksandr Taustyha. All rights reserved.
//

import UIKit

protocol EpisodeInfoModelProtocol: ShowDescriptionModelProtocol {
 
    var episodeNumber: String? { get }
    var season: String? { get }
    
}

class EpisodeInfoModel: ShowDescriptionModel, EpisodeInfoModelProtocol {
    
    private(set) var episodeNumber: String?
    private(set) var season: String?
    
    convenience init(title: String?, info: String?, season: String?, number: String?) {
        self.init(title: title, info: info)
        self.episodeNumber = number
        self.season = season
    }
    
}

class EpisodeInfoCell: ShowDescriptionCell {
    
    @IBOutlet private weak var episodeNumberLabel: UILabel!
    
    override func configure() {
        super.configure()
        guard let episode = model as? EpisodeInfoModelProtocol else {
            return
        }
        
        episodeNumberLabel.isHidden = false
        
        var number = ""
        if let _season = episode.season {
            number = number + "S".localized + _season + " "
        }
        if let _episode = episode.episodeNumber {
            number = number + "Ep".localized + _episode
        }
        episodeNumberLabel.text = number
    }
    
}
