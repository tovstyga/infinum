//
//  LoginInteractor.swift
//  TVShows
//
//  Created by Aliaksandr Taustyha on 11/4/18.
//  Copyright © 2018 Aliaksandr Taustyha. All rights reserved.
//

import Foundation

private struct LoginViewModel: LoginModel {
    var email: String?
    var password: String?
    var remember: Bool
    var loginAvailable: Bool
}

class LoginInteractor {
    
    var credentialsService: CredentialService
    private var _model: LoginViewModel
    
    init(service: CredentialService) {
        self.credentialsService = service
        _model = LoginViewModel(email: credentialsService.userName, password: credentialsService.password, remember: credentialsService.password != nil, loginAvailable: false)
    }
    
    private func validateModel(_ model: LoginModel?) -> Bool {
        
        guard model?.password?.isEmpty == false, isEmailValid(model?.email) == true else {
            return false
        }
        return true
    }
    
    private func isEmailValid(_ email: String?) -> Bool {
        guard let _email = email else {
            return false
        }
        
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: _email)
    }
}

extension LoginInteractor: LoginInteractorProtocol {
    
    var model: LoginModel {
        return _model
    }
    
    func loginChanged(_ login: String?) -> LoginModel {
        _model.email = login
        _model.loginAvailable = validateModel(model)
        return model
    }
    
    func passwordChanged(_ password: String?) -> LoginModel {
        _model.password = password
        _model.loginAvailable = validateModel(model)
        return model
    }
    
    func savingEnabled(_ enabled: Bool) -> LoginModel {
        _model.remember = enabled
        return model
    }
    
    func performLoginWithCompletion(completion: @escaping ((Error?) -> Void)) {
        guard let _email = model.email, let _password = model.password else {
            completion(NSError.commonError)
            return
        }
        
        let request = LoginRequest(email: _email, password: _password)
        LoginCommand(request: request) { [weak self] (response) in
                DispatchQueue.main.async {
                    guard let `self` = self else { return }
                    
                    guard let _response = response else {
                        completion(NSError.commonError)
                        return
                    }
                    
                    if let error = _response.error {
                        completion(error)
                    } else {
                        guard let token = _response.result?.token else {
                            completion(NSError.commonError)
                            return
                        }
                        
                        if self.model.remember {
                            let error = self.credentialsService.saveUserData(userName: self.model.email!, password: self.model.password!, token: token)
                            completion(error)
                        } else {
                            self.credentialsService.removeAll()
                            self.credentialsService.updateToken(token)
                            completion(nil)
                        }
                    }
                }
        }.perform()
    }

}
