//
//  CommentCell.swift
//  TVShows
//
//  Created by Aliaksandr Taustyha on 11/6/18.
//  Copyright © 2018 Aliaksandr Taustyha. All rights reserved.
//

import UIKit
import Kingfisher

protocol CommentCellModelProtocol: DequeuedProtocol {
    
    var imageUrl: URL? { get }
    var userName: String? { get }
    var comment: String? { get }
    
}

class CommentCellModel: CommonCellModel<CommentCell>, CommentCellModelProtocol {
    
    let imageUrl: URL?
    let userName: String?
    let comment: String?
    
    init(imageUrl: URL?, userName: String?, comment: String?) {
        self.imageUrl = imageUrl
        self.userName = userName
        self.comment = comment
    }
}

class CommentCell: CommonCell<CommentCellModelProtocol> {
    
    @IBOutlet private weak var avatarImageView: UIImageView!
    @IBOutlet private weak var userNameLabel: UILabel!
    @IBOutlet private weak var commentLabel: UILabel!
    
    override func configure() {
        avatarImageView.kf.setImage(with: model?.imageUrl, placeholder: placeholder())
        userNameLabel.text = model?.userName
        commentLabel.text = model?.comment
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        avatarImageView.kf.cancelDownloadTask()
    }
    
    private func placeholder() -> UIImage? {
        let random = Int.random(in: 1...3)
        return UIImage(named: "img-placeholder-user\(random)")
    }
}
