//
//  LoginService.swift
//  TVShows
//
//  Created by Aliaksandr Taustyha on 11/1/18.
//  Copyright © 2018 Aliaksandr Taustyha. All rights reserved.
//

import Foundation
import ObjectMapper

class LoginRequest: WebServiceRequest {
    
    private(set) var email: String?
    private(set) var password: String?
    
    override var tag: WebServiceTag? {
        return WebServiceTag.login
    }
    
    convenience init(email: String, password: String) {
        self.init()
        self.email = email
        self.password = password
    }

    override func normalize() -> [String : Any]? {
        let result = DictionaryBuilder()
            .add(super.normalize())
            .add("email", value: email)
            .add("password", value: password)
            .build()
        return result
    }
}

class LoginResponse: WebServiceResponse {
    
    private(set) var result: LoginWebModel?
    
    override func parseDataDictionary(_ data: [String: AnyObject]) {
        result = LoginWebModel(JSON: data)
    }
    
}

class LoginService: WebService<LoginRequest, LoginResponse> {
    
}

class LoginCommand: Command<LoginRequest, LoginResponse> {
    
    internal override func constructService() -> WebService<LoginRequest, LoginResponse>? {
        return factory.loginService()
    }
    
}
