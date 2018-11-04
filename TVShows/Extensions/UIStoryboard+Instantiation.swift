//
//  UIStoryboard+Instantiation.swift
//  TVShows
//
//  Created by Aliaksandr Taustyha on 11/4/18.
//  Copyright © 2018 Aliaksandr Taustyha. All rights reserved.
//

import UIKit

extension UIStoryboard {

    struct instance {
        static let main = UIStoryboard(name: "Main", bundle: nil)
        static let launch = UIStoryboard(name: "LaunchScreen", bundle: nil)
    }
    
    func instantiateViewController<T: UIViewController>(ofType _: T.Type, withIdentifier identifier: String? = nil) -> T {
        let identifier = identifier ?? String(describing: T.self)
        return instantiateViewController(withIdentifier: identifier) as! T
    }

}
