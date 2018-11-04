//
//  UIViewController+Progress.swift
//  TVShows
//
//  Created by Aliaksandr Taustyha on 11/4/18.
//  Copyright © 2018 Aliaksandr Taustyha. All rights reserved.
//

import Foundation
import MBProgressHUD

extension UIViewController {
    
    func showActivityIngicator() {
        MBProgressHUD.showAdded(to: view, animated: true)
    }
    
    func hideActivityIndicator() {
        MBProgressHUD.hide(for: view, animated: true)
    }
    
}
