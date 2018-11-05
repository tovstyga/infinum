//
//  ShowsListCoordinator.swift
//  TVShows
//
//  Created by Aliaksandr Taustyha on 11/4/18.
//  Copyright © 2018 Aliaksandr Taustyha. All rights reserved.
//

import UIKit

protocol ShowsListCoordinatorDataSource: class {
    
    func findShow(identifier: String) -> ShowWebModel?
    
}

class ShowsListCoordinator: Coordinator {
    var rootViewController: UINavigationController
    
    var childCoordinators: [Coordinator] = []
    
    private weak var dataSource: ShowsListCoordinatorDataSource?
    private weak var parent: Coordinator?
    
    init(rootViewController: UINavigationController, parentCoordinator: Coordinator) {
        self.rootViewController = rootViewController
        self.parent = parentCoordinator
    }
    
    func start(with completion: CoordinatorCallback?) {
        let viewController = UIStoryboard.instance.main.instantiateViewController(ofType: ShowsListViewController.self)
        viewController.coordinator = self
        let interactor = ShowsListInteractor()
        self.dataSource = interactor
        viewController.interactor = interactor
        rootViewController.setViewControllers([viewController], animated: true)
    }
    
    func stop(with completion: CoordinatorCallback?) {
        
    }
    
}

extension ShowsListCoordinator: ShowsListCoordinatorProtocol {
    
    func logout() {
        parent?.stopChild(coordinator: self, completion: nil)
    }
    
    func openShow(identifier: String?) {
        guard let id = identifier, let model = dataSource?.findShow(identifier: id) else {
            return
        }
        
        let coordinator = ShowDetailsCoordinator(rootViewController: rootViewController, parentCoordinator: self, model: model)
        startChild(coordinator: coordinator, completion: nil)
    }
    
}
