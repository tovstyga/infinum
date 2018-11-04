//
//  ShowsListCoordinator.swift
//  TVShows
//
//  Created by Aliaksandr Taustyha on 11/4/18.
//  Copyright © 2018 Aliaksandr Taustyha. All rights reserved.
//

import UIKit

class ShowsListCoordinator: Coordinator {
    var rootViewController: UINavigationController
    
    var childCoordinators: [Coordinator] = []
    
    init(rootViewController: UINavigationController) {
        self.rootViewController = rootViewController
    }
    
    func start(with completion: CoordinatorCallback?) {
        let viewController = UIStoryboard.instance.main.instantiateViewController(ofType: ShowsListViewController.self)
        rootViewController.setViewControllers([viewController], animated: true)
    }
    
    func stop(with completion: CoordinatorCallback?) {
        
    }
    
    
}
