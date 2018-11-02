//
//  WebCommand.swift
//  TVShows
//
//  Created by Aliaksandr Taustyha on 11/1/18.
//  Copyright © 2018 Aliaksandr Taustyha. All rights reserved.
//

import Foundation

class Command<Request: WebServiceRequest, Response: WebServiceResponse> {
    
    private(set) var service: WebService<Request, Response>?
    private(set) var request: Request?
    private(set) var response: Response?
    private(set) var result : ((_ response: Response?) -> Void)?
    
    private(set) var factory: WebServiceFactoryAbstract = WebServiceFactory()
    
    required init(request: Request? = nil, result: (( _ response: Response?) -> Void)? = nil) {
        self.request = request
        self.result = result
    }
    
    func perform() {
        
        if let service = constructService() {
            self.service = service
            service.request = request
            service.fetch({ (response) in
                self.response = response
                self.result?(response)
            })
        }
    }
    
    internal func constructService() -> WebService<Request, Response>? {
        preconditionFailure("Command: constructService() must be overriden!")
    }
    
}
