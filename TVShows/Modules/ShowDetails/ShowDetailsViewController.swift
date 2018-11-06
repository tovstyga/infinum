//
//  ShowDetailsViewController.swift
//  TVShows
//
//  Created by Aliaksandr Taustyha on 11/5/18.
//  Copyright © 2018 Aliaksandr Taustyha. All rights reserved.
//

import UIKit
import Kingfisher

protocol ShowDetailsCoordinatorProtocol {
    
    func createNewEpisode()
    func back()
    func openEpisode(identifier: String?)
    
}

protocol ShowDetailsInteractorProtocol {
    
    var episodes: [EpisodeCellModelProtocol] { get }
    var showInfo: ShowDescriptionModelProtocol { get }
    var imageUrl: URL? { get }
    
    func reloadData(completion: @escaping ((_ error: Error?) -> Void))
    func identifierForModel(_ model: EpisodeCellModelProtocol) -> String?
    
}

class ShowDetailsViewController: UIViewController {

    var interactor: ShowDetailsInteractorProtocol?
    var coordinator: ShowDetailsCoordinatorProtocol?
    
    private var currentAlpha: CGFloat = 0 {
        didSet {
            let image = UIImage.from(color: .white, alpha: currentAlpha)
            navigationController?.navigationBar.setBackgroundImage(image, for: .default)
            navigationController?.navigationBar.shadowImage = image
        }
    }
    private var defaultOffset: CGFloat {
        //30 - shadow height
        return imageVeiw.frame.height - 30 - tableView.frame.minY
    }
    
    var isCreationNewAvaiable: Bool = true
    @IBOutlet private weak var addButton: UIButton! {
        didSet {
            addButton.isHidden = !isCreationNewAvaiable
        }
    }
    @IBOutlet private weak var imageVeiw: UIImageView!
    @IBOutlet private weak var tableView: UITableView! {
        didSet {
            tableView.delegate = self
            tableView.dataSource = self
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        customize()
        update()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
        currentAlpha = 0
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.contentInset = UIEdgeInsets(top: defaultOffset, left: 0, bottom: 0, right: 0)
    }
    
    @IBAction func addNewAction(_ sender: UIButton) {
        coordinator?.createNewEpisode()
    }
    
    @IBAction func backAction(_ sender: UIButton)  {
        coordinator?.back()
    }
    
    private func customize() {
        navigationController?.navigationBar.setBackgroundImage(UIImage.from(color: .clear), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        
        let backButton = UIButton(frame: CGRect.init(x: 0, y: 0, width: 40, height: 40))
        backButton.setImage(UIImage(named: "ic-navigate-back"), for: .normal)
        backButton.addTarget(self, action: #selector(ShowDetailsViewController.backAction(_:)), for: .touchUpInside)
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
        
        imageVeiw.layer.masksToBounds = true
        
    }
    
    @objc private func update() {
        
        guard let _interactor = interactor else {
            return
        }
        
        imageVeiw.kf.setImage(with: _interactor.imageUrl, placeholder: UIImage.instance.placeholder)
        tableView.reloadRows(at: [IndexPath(row: 0, section: 0)], with: .none)
        self.showActivityIngicator()
        interactor?.reloadData(completion: { [weak self] error in
            guard let `self` = self else {
                return
            }
            self.hideActivityIndicator()
            self.presentAlertForError(error)
            self.imageVeiw.kf.setImage(with: self.interactor?.imageUrl, placeholder: UIImage.instance.placeholder)
            self.tableView.reloadData()
        })
    }
    
}

extension ShowDetailsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let _interactor = interactor, indexPath.row > 1 else {
            return
        }
        coordinator?.openEpisode(identifier: interactor?.identifierForModel(_interactor.episodes[indexPath.row - 2]))
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let delta = ((defaultOffset + scrollView.contentOffset.y) / defaultOffset * 100).rounded()
        
        if delta < 0 {
            if currentAlpha != 0 {
                currentAlpha = 0
            }
            return
        } else if delta > 100 {
            if currentAlpha != 1 {
                currentAlpha = 1
            }
            return
        }
        
        if (currentAlpha * 100).rounded() != delta {
            currentAlpha = delta / 100
        }
        
    }
    
}

extension ShowDetailsViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let _interactor = interactor else {
            return 0
        }
        
        if _interactor.episodes.count > 0 {
            return 1 + 1 + _interactor.episodes.count
        } else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let _interactor = interactor else {
            return UITableViewCell()
        }
        
        switch indexPath.row {
        case 0:
            return _interactor.showInfo.dequeueCellAtIndexPath(indexPath, tableView: tableView)
        case 1:
            return EpisodeCounterModel(counter: _interactor.episodes.count).dequeueCellAtIndexPath(indexPath, tableView: tableView)
        default:
            return _interactor.episodes[indexPath.row - 2].dequeueCellAtIndexPath(indexPath, tableView: tableView)
        }
        
    }
    
}

extension ShowDetailsViewController: ShowDetailsCoordinatorDelegate {
    
    func newEpisodeCreated() {
        update()
    }
    
}
