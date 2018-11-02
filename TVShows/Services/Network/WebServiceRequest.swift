//
//  WebServiceRequest.swift
//  TVShows
//
//  Created by Aliaksandr Taustyha on 11/1/18.
//  Copyright © 2018 Aliaksandr Taustyha. All rights reserved.
//

import Foundation
import Alamofire

protocol Serializable {
    func normalize() -> [String: Any]?
}

protocol WebServiceRequestProtocol: class, Serializable {
    var endpoint: String? {get}
    var method: HTTPMethod {get}
    var parameters: [String: Any]? {get}
    var encoding: ParameterEncoding {get}
    var headers: [String: String]? {get set}
    var identifier: String {get}
    init(endpoint: String?, method: HTTPMethod, parameters: [String: Any]?, encoding: ParameterEncoding, headers: [String: String]?, identifier: String?)
}

class WebServiceRequest: WebServiceRequestProtocol {
    
    private var _endpoint: String?
    var endpoint: String? {
        set {
            _endpoint = newValue
        }
        get {
            _ = constructEndpoint()
            return _endpoint
        }
    }
    var method = HTTPMethod.post
    var parameters: [String: Any]?
    var encoding: ParameterEncoding = JSONEncoding.default
    var headers: [String: String]?
    var identifier: String = UUID().uuidString
    
    var tag: WebServiceTag? {
        return nil
    }
    
    required init(endpoint: String? = nil, method: HTTPMethod = .post, parameters: [String: Any]? = nil, encoding: ParameterEncoding = JSONEncoding.default, headers: [String: String]? = nil, identifier: String? = nil) {
        self.endpoint = endpoint
        self.method = method
        self.parameters = parameters
        self.encoding = encoding
        self.headers = headers
        if let id = identifier {
            self.identifier = id
        }
    }
    
    func normalize() -> [String: Any]? {
        return parameters
    }
    
    func constructEndpoint() -> String? {
        guard let _tag = tag, let endpoint = WebConfiguration(webServiceTag: _tag)?.baseUrl else {
            return nil
        }
        _endpoint = _endpoint ?? endpoint
        return _endpoint
    }
}
