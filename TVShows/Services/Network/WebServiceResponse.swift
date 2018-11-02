//
//  WebServiceResponse.swift
//  TVShows
//
//  Created by Aliaksandr Taustyha on 11/1/18.
//  Copyright © 2018 Aliaksandr Taustyha. All rights reserved.
//

import Foundation
import Alamofire

enum ResponseStatus {
    case success
    case error
}

protocol WebServiceResponseProtocol: class {
    
    var status: ResponseStatus {get}
    var source: AnyObject? {get}
    var error: Error? {get}
    var statusCode: Int? {get}
    
    init(source: AnyObject?, error: Error?, statusCode: Int?)
    
    func parseDataDictionary(_ data: [String: AnyObject])
    func parseDataArray(_ data: [AnyObject])
    func customParseResponse(_ someResponse: AnyObject)
    func parseDictionary(_ data: [String: AnyObject])
    func parseArray(_ data: [AnyObject])
    func parseObject(_ data: AnyObject)
    func process(nativeResponse response: HTTPURLResponse?)
}

class WebServiceResponse: WebServiceResponseProtocol {
    
    var statusCode: Int?
    var status: ResponseStatus = .error
    var source: AnyObject?
    var error: Error?
    var responseDate: Date = Date()
    
    required init(source: AnyObject?, error: Error?, statusCode: Int?) {
        self.source = source
        self.error = error
        self.statusCode = statusCode
        
        if self.error == nil {
            self.error = WebServiceResponseValidator(response: source).validate()
        }
    
        status = self.error == nil ? .success : .error
        
        if let object = source as? [String: AnyObject] {
            
            if let data = object["data"] {
                if let dataDictionary = data as? [String: AnyObject] {
                    parseDataDictionary(dataDictionary)
                } else if let dataArray = data as? [AnyObject] {
                    parseDataArray(dataArray)
                } else if data is NSNull {
                    customParseResponse(object as AnyObject)
                }
            } else {
                parseDictionary(object)
            }
        } else if let object = source as? [AnyObject] {
            parseArray(object)
        } else if let object = source {
            parseObject(object)
        }
        
    }
    
    func parseDataDictionary(_ data: [String: AnyObject]) {
        
    }
    
    func parseDataArray(_ data: [AnyObject]) {
        
    }
    
    func customParseResponse(_ someResponse: AnyObject) {
        
    }
    
    func parseDictionary(_ data: [String: AnyObject]) {
        
    }
    
    func parseArray(_ data: [AnyObject]) {
        
    }
    
    func parseObject(_ data: AnyObject) {
        
    }
    
    func process(nativeResponse response: HTTPURLResponse?) {
        
    }
}
