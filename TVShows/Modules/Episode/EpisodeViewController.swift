//
//  EpisodeViewController.swift
//  TVShows
//
//  Created by Aliaksandr Taustyha on 11/5/18.
//  Copyright © 2018 Aliaksandr Taustyha. All rights reserved.
//

import UIKit

protocol EpisodeCoordinatorProtocol: ShowDetailsCoordinatorProtocol {
    
    func openComments()
    
}

class EpisodeViewController: ShowDetailsViewController {

    @IBOutlet private weak var commentsView: UIView!
    @IBOutlet private weak var commentsLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if !(coordinator is EpisodeCoordinatorProtocol) {
            commentsView.removeFromSuperview()
        }
        localize()
    }
    
    private func localize() {
        commentsLabel?.text = commentsLabel?.text?.localized
    }
    
    @IBAction private func openCommentsAction() {
        (coordinator as? EpisodeCoordinatorProtocol)?.openComments()
    }
    
}
