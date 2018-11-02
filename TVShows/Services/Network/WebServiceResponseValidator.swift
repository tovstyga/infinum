//
//  WebServiceResponseValidator.swift
//  TVShows
//
//  Created by Aliaksandr Taustyha on 11/1/18.
//  Copyright © 2018 Aliaksandr Taustyha. All rights reserved.
//

import Foundation

class WebServiceResponseValidator {
    
    private let response: AnyObject?
    
    init(response: AnyObject?) {
        self.response = response
    }
    
    func validate() -> Error? {
        return WebServiceResponseErrorFactory(response: response).create().first
    }
    
}

class WebServiceResponseErrorFactory {

    private let response: AnyObject?
    
    required init(response: AnyObject?) {
        self.response = response
    }
    
    func create() -> [Error] {
        var result = [Error]()
        
        if let source = response as? [String: AnyObject] {
            
            if let errors = source["errors"] as? [String] {
                result = errors.map { message -> Error in
                    return NSError.networkErrorWithMessage(message)
                }
            }
        }
        return result
    }
}
