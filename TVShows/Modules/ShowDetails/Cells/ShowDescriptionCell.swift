//
//  ShowDescriptionCell.swift
//  TVShows
//
//  Created by Aliaksandr Taustyha on 11/5/18.
//  Copyright © 2018 Aliaksandr Taustyha. All rights reserved.
//

import UIKit

protocol ShowDescriptionModelProtocol: DequeuedProtocol {
    
    var title: String? { get }
    var info: String? { get }
    
}

class ShowDescriptionModel: CommonCellModel<ShowDescriptionCell>, ShowDescriptionModelProtocol {
    
    var title: String?
    var info: String?
    
    init(title: String?, info: String?) {
        self.title = title
        self.info = info
    }
    
}

class ShowDescriptionCell: CommonCell<ShowDescriptionModelProtocol> {

    @IBOutlet private weak var showTitleLabel: UILabel!
    @IBOutlet private weak var showDescriptionLabel: UILabel!
    
    override func configure() {
        showTitleLabel.text = model?.title
        showDescriptionLabel.text = model?.info
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        model = nil
    }

}
