//
//  ShowsListViewControllerTableViewController.swift
//  TVShows
//
//  Created by Aliaksandr Taustyha on 11/4/18.
//  Copyright © 2018 Aliaksandr Taustyha. All rights reserved.
//

import UIKit

protocol ShowsListCoordinatorProtocol {
    
    func logout()
    func openShow(identifier: String?)
    
}

protocol ShowsListInteractorProtocol {
    
    var data: [ShowListCellModelProtocol] { get }
    
    func reloadData(completion: @escaping ((_ error: Error?) -> Void))
    func identifierForModel(_ model: ShowListCellModelProtocol) -> String?
    
}

class ShowsListViewController: UITableViewController {

    var coordinator: ShowsListCoordinatorProtocol?
    var interactor: ShowsListInteractorProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        customize()
        update()
    }

    private func customize() {
        navigationController?.setNavigationBarHidden(false, animated: true)
        navigationController?.navigationBar.setBackgroundImage(UIImage.from(color: .white), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        
        let label = UILabel()
        label.textColor = UIColor.app.darkGray
        label.font = UIFont.boldSystemFont(ofSize: 28)
        label.text = "Shows".localized
        label.lineBreakMode = .byTruncatingTail
        label.numberOfLines = 1
        label.textAlignment = .left
        let size = label.sizeThatFits(CGSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude))
        label.frame = CGRect(origin: CGPoint.zero, size: CGSize(width: size.width + 10, height: size.height))
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: label)
        
        let logoutButton = UIButton(frame: CGRect.init(x: 0, y: 0, width: 40, height: 40))
        logoutButton.setImage(UIImage(named: "ic-logout"), for: .normal)
        logoutButton.addTarget(self, action: #selector(ShowsListViewController.logoutAction(_:)), for: .touchUpInside)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: logoutButton)
        
        let refreshControl = UIRefreshControl()
        tableView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(ShowsListViewController.update), for: .valueChanged)
    
    }
    
    @IBAction private func update() {
        guard let _interactor = interactor else {
            return
        }
        
        if refreshControl?.isRefreshing == false {
            refreshControl?.beginRefreshing()
        }
        
        _interactor.reloadData {[weak self] error in
            guard let `self` = self else {
                return
            }
            
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.1, execute: {
                self.refreshControl?.endRefreshing()
            })
            
            self.presentAlertForError(error)
            self.tableView.reloadData()
        }
    }
    
    @IBAction func logoutAction(_ sender: UIButton) {
        coordinator?.logout()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return interactor?.data.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let model = interactor?.data[indexPath.row] else {
            return UITableViewCell()
        }
        
        return model.dequeueCellAtIndexPath(indexPath, tableView: tableView)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let _interactor = interactor else {
            return
        }
        
        coordinator?.openShow(identifier: _interactor.identifierForModel(_interactor.data[indexPath.row]))
    }
    
}
