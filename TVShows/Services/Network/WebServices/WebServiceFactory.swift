//
//  WebServiceFactory.swift
//  TVShows
//
//  Created by Aliaksandr Taustyha on 11/1/18.
//  Copyright © 2018 Aliaksandr Taustyha. All rights reserved.
//

import Foundation

class WebServiceFactoryAbstract {
    
    func createLoginService() -> WebService<LoginRequest, LoginResponse>? {
        return nil
    }
    
}

class WebServiceFactory: WebServiceFactoryAbstract {
    
    override func createLoginService() -> WebService<LoginRequest, LoginResponse>? {
        return LoginService()
    }
}
