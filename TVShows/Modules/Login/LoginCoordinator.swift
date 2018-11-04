//
//  LoginCoordinator.swift
//  TVShows
//
//  Created by Aliaksandr Taustyha on 11/4/18.
//  Copyright © 2018 Aliaksandr Taustyha. All rights reserved.
//

import UIKit

class LoginCoordinator: Coordinator {
    
    var rootViewController: UINavigationController
    
    var childCoordinators: [Coordinator] = []
    private let service: CredentialService
    private weak var parent: Coordinator?
    
    init(rootViewController: UINavigationController, parentCoordinator: Coordinator, credentials: CredentialService) {
        self.rootViewController = rootViewController
        self.service = credentials
        self.parent = parentCoordinator
    }
    
    func start(with completion: CoordinatorCallback?) {
        let viewController = UIStoryboard.instance.main.instantiateViewController(ofType: LoginViewController.self)
        viewController.coordinator = self
        viewController.interactor = LoginInteractor(service: service)
        rootViewController.setViewControllers([viewController], animated: true)
    }
    
    func stop(with completion: CoordinatorCallback?) {
        
    }
    
}

extension LoginCoordinator: LoginCoordinatorProtocol {
    
    func hideViewController() {
        parent?.stopChild(coordinator: self, completion: nil)
    }
    
}
