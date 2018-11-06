//
//  CreateNewEpisodeCoordinator.swift
//  TVShows
//
//  Created by Aliaksandr Taustyha on 11/6/18.
//  Copyright © 2018 Aliaksandr Taustyha. All rights reserved.
//

import UIKit

protocol CreateNewEpisodeCoordinatorDelegate: class {
    
    func episodeCreated()
    
}

class CreateNewEpisodeCoordinator: Coordinator {
    
    var rootViewController: UINavigationController
    
    var childCoordinators: [Coordinator] = []
    
    weak var delegate: CreateNewEpisodeCoordinatorDelegate?
    
    private let parent: Coordinator
    private let model: ShowWebModel
    
    init(rootViewController: UINavigationController, parentCoordinator: Coordinator, model: ShowWebModel) {
        self.rootViewController = rootViewController
        self.parent = parentCoordinator
        self.model = model
    }
    
    func start(with completion: CoordinatorCallback?) {
        let viewController = UIStoryboard.instance.main.instantiateViewController(ofType: CreateNewEpisodeViewController.self)
        viewController.interactor = CreateNewEpisodeInteractor(show: model)
        viewController.coordinator = self
        rootViewController.pushViewController(viewController, animated: true)
    }
    
    func stop(with completion: CoordinatorCallback?) {
        rootViewController.popViewController(animated: true)
        completion?(self)
    }
    
}

extension CreateNewEpisodeCoordinator: CreateNewEpisodeCoordinatorProtocol {
    
    func back(needsReload: Bool) {
        parent.stopChild(coordinator: self) { coordinator in
            if needsReload {
                self.delegate?.episodeCreated()
            }
        }
    }
    
}
