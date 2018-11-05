//
//  ApplicationCoordinator.swift
//  TVShows
//
//  Created by Aliaksandr Taustyha on 11/3/18.
//  Copyright © 2018 Aliaksandr Taustyha. All rights reserved.
//

import UIKit

class AppCoordinator: Coordinator {
    
    lazy var rootViewController: UINavigationController = {
        return UINavigationController(rootViewController: UIViewController())
    }()
    
    var childCoordinators: [Coordinator] = []
    
    let window: UIWindow
    
    private let credentialsService = CredentialService()
    
    public init(window: UIWindow) {
        self.window = window
        self.window.backgroundColor = .white
        self.window.rootViewController = self.rootViewController
        self.window.makeKeyAndVisible()
        
        NotificationCenter.default.addObserver(self, selector: #selector(AppCoordinator.logout), name: Notification.Name.app.invalidCredentialsNotification, object: nil)
        
        setupAppearance()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    func setupAppearance() {
        rootViewController.setNavigationBarHidden(true, animated: false)
    }
    
    func start(with completion: CoordinatorCallback?) {
        if credentialsService.isUserSaved {
            presentMainScreen()
        } else {
            logout()
        }
    }
    
    func stop(with completion: CoordinatorCallback?) {
        print("Can't stop root coordinator")
    }
    
    func stopChild(coordinator: Coordinator, completion: CoordinatorCallback?) {
        let index = childCoordinators.index { $0 === coordinator }
        guard let childIndex = index else { return }
        
        coordinator.stop { (coordinator) in
            self.childCoordinators.remove(at: childIndex)
            completion?(coordinator)
        }
        
        if coordinator is LoginCoordinator {
            presentMainScreen()
        } else if coordinator is ShowsListCoordinator {
            logout()
        }
    }
    
    @objc private func logout() {
        credentialsService.removeAll()
        presentLoginScreen()
    }
    
    private func presentLoginScreen() {
        let loginCoordinator = LoginCoordinator(rootViewController: rootViewController, parentCoordinator: self, credentials: credentialsService)
        startChild(coordinator: loginCoordinator, completion: nil)
    }
    
    private func presentMainScreen() {
        let showsCoordinator = ShowsListCoordinator(rootViewController: rootViewController, parentCoordinator: self)
        startChild(coordinator: showsCoordinator, completion: nil)
    }
}
