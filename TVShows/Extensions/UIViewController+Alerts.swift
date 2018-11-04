//
//  UIViewController+Alerts.swift
//  TVShows
//
//  Created by Aliaksandr Taustyha on 11/4/18.
//  Copyright © 2018 Aliaksandr Taustyha. All rights reserved.
//

import UIKit

extension UIViewController {
    
    func presentAlertForError(_ error: Error?) {
        guard let _error = error else {
            return
        }
        
        let alert = UIAlertController(title: "Error".localized, message: _error.localizedDescription, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok".localized, style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
}
