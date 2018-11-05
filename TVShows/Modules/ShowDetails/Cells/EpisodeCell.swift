//
//  EpisodeCell.swift
//  TVShows
//
//  Created by Aliaksandr Taustyha on 11/5/18.
//  Copyright © 2018 Aliaksandr Taustyha. All rights reserved.
//

import UIKit

protocol EpisodeCellModelProtocol: class, DequeuedProtocol {
    
    var episodeName: String? { get }
    var episodeNumber: String? { get }
    var season: String? { get }
    
}

class EpisodeCellModel: CommonCellModel<EpisodeCell>, EpisodeCellModelProtocol {
    
    let identifier: String
    let episodeName: String?
    let episodeNumber: String?
    let season: String?
    
    init(identifier: String, name: String?, number: String?, season: String?) {
        self.identifier = identifier
        self.episodeName = name
        self.episodeNumber = number
        self.season = season
    }
    
}

class EpisodeCell: CommonCell<EpisodeCellModelProtocol> {

    @IBOutlet private weak var episodeNumnerLabel: UILabel!
    @IBOutlet private weak var episodeNameLabel: UILabel!

    override func configure() {
        var number = ""
        if let _season = model?.season {
            number = number + "S".localized + _season + " "
        }
        if let _episode = model?.episodeNumber {
            number = number + "Ep".localized + _episode
        }
        episodeNumnerLabel.text = number
        episodeNameLabel.text = model?.episodeName
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        model = nil
    }
    
}
