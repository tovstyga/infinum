//
//  AuthorizationService.swift
//  TVShows
//
//  Created by Aliaksandr Taustyha on 11/4/18.
//  Copyright © 2018 Aliaksandr Taustyha. All rights reserved.
//

import Foundation

class AuthorizationService: AuthorizationServiceProtocol {
    
    private let credentialService: CredentialService
    
    init(service: CredentialService) {
        self.credentialService = service
    }
    
    func authorizationHeaders() -> [String : String]? {
        guard let token = credentialService.token else {
            return nil
        }
        
        return ["Authorization": token]
    }
    
    func isContainAuthError(_ response: HTTPURLResponse) -> Bool {
        return response.statusCode == 401
    }
    
    func relogin(_ completion: @escaping (Bool) -> Void) {
    
        guard let login = credentialService.userName, let password = credentialService.password else {
            completion(false)
            return
        }
        
        let request = LoginRequest(email: login, password: password)
        LoginCommand(request: request) {[weak self] response in
            guard let `self` = self else { return }
            guard let token = response?.result?.token else {
                if response?.statusCode == 401 {
                    NotificationCenter.default.post(name: Notification.Name.app.invalidCredentialsNotification, object: nil)
                }
                completion(false)
                return
            }
            
            self.credentialService.updateToken(token)
            completion(true)
        }.perform()
        
    }
    
}
