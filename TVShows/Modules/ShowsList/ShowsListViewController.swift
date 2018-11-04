//
//  ShowsListViewControllerTableViewController.swift
//  TVShows
//
//  Created by Aliaksandr Taustyha on 11/4/18.
//  Copyright © 2018 Aliaksandr Taustyha. All rights reserved.
//

import UIKit

class ShowsListViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    @IBAction func logoutAction(_ sender: UIButton) {
        NotificationCenter.default.post(name: Notification.Name.app.invalidCredentialsNotification, object: nil)
    }
    
}
