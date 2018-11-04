//
//  WebService.swift
//  TVShows
//
//  Created by Aliaksandr Taustyha on 11/1/18.
//  Copyright © 2018 Aliaksandr Taustyha. All rights reserved.
//

import Foundation

protocol AuthorizationServiceProtocol: class {
    
    func authorizationHeaders() -> [String: String]?
    func isContainAuthError(_ response: HTTPURLResponse) -> Bool
    func relogin(_ completion: @escaping (_ success: Bool) -> Void)
    
}

class WebService<TRequest: WebServiceRequestProtocol, TResponse: WebServiceResponseProtocol>: BaseNetworkingService {
    
    var authService: AuthorizationServiceProtocol?
    
    override var additionalHeaders: [AnyHashable: Any]? {
    
        return ["Content-Type": "application/json",
                "Accept": "application/json"
        ]
    }
    
    var request: TRequest?
    var response: TResponse?
    
    func fetch(_ completion: ((TResponse) -> Void)?) {
        if !performRequest(request, completion: completion) {
            completion?(TResponse(source: nil, error: NSError.invalidRequestError, statusCode:400))
        }
    }
    
    internal func performRequest(_ request: TRequest?, retryIfNeeded retry: Bool, completion: ((TResponse) -> Void)?) -> Bool {
        if let request = request {
            guard let URLString = WebServiceURLStringBuilder(baseUrl: self.baseURLString)?.appendEndpoint(request.endpoint).build() else {
                return false
            }
            
            if let authHeaders = authService?.authorizationHeaders(), request.headers != nil {
                for (key, value) in authHeaders {
                    request.headers![key] = value
                }
            }
            
            let params = request.normalize()
            let networkRequest = manager.request(URLString,
                                                 method: request.method,
                                                 parameters: params,
                                                 encoding: request.encoding,
                                                 headers: request.headers)
                .validate(statusCode: 200...500)
                .responseJSON { response in
                    
                    let processBlock = {
                        if self.removeRequestWhenComplete == true {
                            self.removeRequest(withKey: request.identifier)
                        }
                        
                        let result = TResponse(source: response.result.value as AnyObject, error: response.result.error as NSError?, statusCode:response.response?.statusCode)
                        result.process(nativeResponse: response.response)
                        self.response = result
                        completion?(result)
                    }
                    
                    if let _authService = self.authService, let _response = response.response, retry == true {
                        if _authService.isContainAuthError(_response) {
                            _authService.relogin({ (success) in
                                if success {
                                    if !self.performRequest(request, retryIfNeeded: false, completion: completion) {
                                        processBlock()
                                    }
                                } else {
                                    processBlock()
                                }
                            })
                        } else {
                            processBlock()
                        }
                    } else {
                        processBlock()
                    }
            }
            
            addRequest(request: networkRequest, forKey: request.identifier)
            networkRequest.resume()
            
            return true
        }
        
        return false
    }
    
    func performRequest(_ request: TRequest?, completion: ((TResponse) -> Void)?) -> Bool {
        return performRequest(request, retryIfNeeded: true, completion: completion)
    }

}
