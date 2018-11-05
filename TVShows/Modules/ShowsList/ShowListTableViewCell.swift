//
//  ShowListTableViewCell.swift
//  TVShows
//
//  Created by Aliaksandr Taustyha on 11/4/18.
//  Copyright © 2018 Aliaksandr Taustyha. All rights reserved.
//

import UIKit
import Kingfisher

protocol ShowListCellModelProtocol: class {
    
    var title: String? { get }
    var imageUrl: URL? { get }
    
    func dequeueCellAtIndexPath(_ indexPath: IndexPath, tableView: UITableView) -> UITableViewCell
}

class ShowListCellModel: ShowListCellModelProtocol {
    let identifier: String
    let title: String?
    let imageUrl: URL?
    
    init(identifier: String, title: String?, url: URL?) {
        self.title = title
        self.imageUrl = url
        self.identifier = identifier
    }
    
    func dequeueCellAtIndexPath(_ indexPath: IndexPath, tableView: UITableView) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(class: ShowListTableViewCell.self, indexPath: indexPath) else {
            return UITableViewCell()
        }
        
        cell.model = self
        return cell
    }
    
}

class ShowListTableViewCell: UITableViewCell {

    @IBOutlet private weak var showNameLabel: UILabel!
    @IBOutlet private weak var showIcon: UIImageView!
    
    private var _model: ShowListCellModelProtocol?
    var model: ShowListCellModelProtocol? {
        set {
            _model = newValue
            configure()
        }
        get {
            return _model
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        customize()
    }
    
    private func configure() {
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
