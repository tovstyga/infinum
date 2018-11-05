//
//  ShowListTableViewCell.swift
//  TVShows
//
//  Created by Aliaksandr Taustyha on 11/4/18.
//  Copyright © 2018 Aliaksandr Taustyha. All rights reserved.
//

import UIKit
import Kingfisher

protocol ShowListCellModelProtocol: class, DequeuedProtocol {
    
    var title: String? { get }
    var imageUrl: URL? { get }
    
}

class ShowListCellModel: CommonCellModel<ShowListTableViewCell>, ShowListCellModelProtocol {
    
    let identifier: String
    let title: String?
    let imageUrl: URL?
    
    init(identifier: String, title: String?, url: URL?) {
        self.title = title
        self.imageUrl = url
        self.identifier = identifier
    }

}

class ShowListTableViewCell: CommonCell<ShowListCellModelProtocol> {

    @IBOutlet private weak var showNameLabel: UILabel!
    @IBOutlet private weak var showIcon: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        customize()
    }
    
    override func configure() {
        showNameLabel.text = model?.title
        showIcon.kf.setImage(with: model?.imageUrl, placeholder: UIImage.instance.placeholder)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        showIcon.kf.cancelDownloadTask()
        model = nil
    }
    
    private func customize() {
        showIcon.layer.cornerRadius = 5
        showIcon.layer.masksToBounds = true
        showIcon.layer.borderColor = UIColor.app.ultraLightGray.cgColor
        showIcon.layer.borderWidth = 1
    }
    

}
