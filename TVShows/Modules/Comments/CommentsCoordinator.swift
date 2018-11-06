//
//  CommentsCoordinator.swift
//  TVShows
//
//  Created by Aliaksandr Taustyha on 11/6/18.
//  Copyright © 2018 Aliaksandr Taustyha. All rights reserved.
//

import UIKit

class CommentsCoordinator: Coordinator {
    var rootViewController: UINavigationController
    private weak var parent: Coordinator?
    private var model: EpisodeWebModel
    
    var childCoordinators: [Coordinator] = []
    
    init(rootViewController: UINavigationController, parentCoordinator: Coordinator, model: EpisodeWebModel) {
        self.rootViewController = rootViewController
        self.parent = parentCoordinator
        self.model = model
    }
    
    func start(with completion: CoordinatorCallback?) {
        let viewController = UIStoryboard.instance.main.instantiateViewController(ofType: CommentsViewController.self)
        viewController.coordinator = self
        viewController.interactor = CommentsInteractor(episode: model)
        rootViewController.pushViewController(viewController, animated: true)
    }
    
    func stop(with completion: CoordinatorCallback?) {
        rootViewController.popViewController(animated: true)
    }
    
}

extension CommentsCoordinator: CommentsCoordinatorProtocol {
    
    func back() {
        parent?.stopChild(coordinator: self, completion: nil)
    }
}
