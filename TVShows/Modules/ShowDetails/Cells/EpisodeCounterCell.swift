//
//  EpisodeCounterCell.swift
//  TVShows
//
//  Created by Aliaksandr Taustyha on 11/5/18.
//  Copyright © 2018 Aliaksandr Taustyha. All rights reserved.
//

import UIKit

protocol EpisodeCounterModelProtocol: DequeuedProtocol {
    
    var counter: Int { get }
    
}

class EpisodeCounterModel: CommonCellModel<EpisodeCounterCell>, EpisodeCounterModelProtocol {
    
    let counter: Int
    
    init(counter: Int) {
        self.counter = counter
    }
    
}

class EpisodeCounterCell: CommonCell<EpisodeCounterModelProtocol> {

    @IBOutlet private weak var episodeTitleLabel: UILabel!
    @IBOutlet private weak var episodeCounterLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        localize()
    }
    
    override func configure() {
        guard let counter = model?.counter else {
            return
        }
        episodeCounterLabel.text = counter > 0 ? "\(counter)" : nil
    }
    
    private func localize() {
        episodeTitleLabel.text = episodeTitleLabel.text?.localized
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        model = nil
    }
}
