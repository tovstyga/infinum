//
//  EpisodeCoordinator.swift
//  TVShows
//
//  Created by Aliaksandr Taustyha on 11/5/18.
//  Copyright © 2018 Aliaksandr Taustyha. All rights reserved.
//

import UIKit

class EpisodeCoordinator: Coordinator {
    
    var rootViewController: UINavigationController
    
    var childCoordinators: [Coordinator] = []
    
    private var parent: Coordinator?
    private var model: EpisodeWebModel?
    
    init(rootViewController: UINavigationController, parentCoordinator: Coordinator, model: EpisodeWebModel) {
        self.rootViewController = rootViewController
        self.parent = parentCoordinator
        self.model = model
    }
    
    func start(with completion: CoordinatorCallback?) {
        let viewController = UIStoryboard.instance.main.instantiateViewController(ofType: EpisodeViewController.self)
        viewController.coordinator = self
        viewController.interactor = EpisodeInteractor(episode: model)
        viewController.isCreationNewAvaiable = false
        rootViewController.pushViewController(viewController, animated: true)
    }
    
    func stop(with completion: CoordinatorCallback?) {
        rootViewController.popViewController(animated: true)
    }
    
}

extension EpisodeCoordinator: EpisodeCoordinatorProtocol {
    
    func openComments() {
        
    }
    
    func createNewEpisode() {
        
    }
    
    func back() {
        parent?.stopChild(coordinator: self, completion: nil)
    }
    
    func openEpisode(identifier: String?) {
        
    }
    
}
