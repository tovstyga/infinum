//
//  CommonCell.swift
//  TVShows
//
//  Created by Aliaksandr Taustyha on 11/5/18.
//  Copyright © 2018 Aliaksandr Taustyha. All rights reserved.
//

import UIKit

protocol ModelBindable {
    
    func bindWithModel(_ model: AnyObject)
    
}

protocol DequeuedProtocol {
    
    func dequeueCellAtIndexPath(_ indexPath: IndexPath, tableView: UITableView) -> UITableViewCell
    
}

class CommonCellModel<T: UITableViewCell>: DequeuedProtocol where T: ModelBindable {
    
    func dequeueCellAtIndexPath(_ indexPath: IndexPath, tableView: UITableView) -> UITableViewCell {
    
        guard let cell = tableView.dequeueReusableCell(class: T.self, indexPath: indexPath) else {
            return UITableViewCell()
        }
    
        cell.bindWithModel(self)
        
        return cell
    }
}

class CommonCell<M: Any>: UITableViewCell, ModelBindable {

    private var _model: M?
    var model: M? {
        set {
            _model = newValue
            configure()
        }
        get {
            return _model
        }
    }
    
    func bindWithModel(_ model: AnyObject) {
        if let object = model as? M {
            self.model = object
        }
    }

    internal func configure() {
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        model = nil
    }
    
}
