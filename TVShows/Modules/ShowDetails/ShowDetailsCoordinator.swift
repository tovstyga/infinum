//
//  ShowDetailsCoordinator.swift
//  TVShows
//
//  Created by Aliaksandr Taustyha on 11/5/18.
//  Copyright © 2018 Aliaksandr Taustyha. All rights reserved.
//

import UIKit

protocol ShowDetailsCoordinatorDataSource: class {
    
    func findEpisode(identifier: String) -> EpisodeWebModel?
    
}

protocol ShowDetailsCoordinatorDelegate: class {
    
    func newEpisodeCreated()
    
}

class ShowDetailsCoordinator: Coordinator {
    
    var rootViewController: UINavigationController
    var childCoordinators: [Coordinator] = []
    
    private weak var dataSource: ShowDetailsCoordinatorDataSource?
    private weak var delegate: ShowDetailsCoordinatorDelegate?
    
    private weak var parent: Coordinator?
    private var model: ShowWebModel
    
    init(rootViewController: UINavigationController, parentCoordinator: Coordinator, model: ShowWebModel) {
        self.rootViewController = rootViewController
        self.parent = parentCoordinator
        self.model = model
    }
    
    func start(with completion: CoordinatorCallback?) {
        let viewController = UIStoryboard.instance.main.instantiateViewController(ofType: EpisodeViewController.self)
        self.delegate = viewController
        viewController.coordinator = self
        let interactor = ShowDetailsInteractor(show: model)
        self.dataSource = interactor
        viewController.interactor = interactor
        rootViewController.pushViewController(viewController, animated: true)
    }
    
    func stop(with completion: CoordinatorCallback?) {
        rootViewController.popViewController(animated: true)
    }
    
}

extension ShowDetailsCoordinator: ShowDetailsCoordinatorProtocol {
    
    func createNewEpisode() {
        
    }
    
    func back() {
        parent?.stopChild(coordinator: self, completion: nil)
    }
    
    func openEpisode(identifier: String?) {
        guard let id = identifier, let episode = dataSource?.findEpisode(identifier: id) else {
            return
        }
        
        let coordinator = EpisodeCoordinator(rootViewController: rootViewController, parentCoordinator: self, model: episode)
        startChild(coordinator: coordinator, completion: nil)
    }
    
}
