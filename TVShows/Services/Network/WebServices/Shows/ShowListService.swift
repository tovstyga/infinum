//
//  ShowListService.swift
//  TVShows
//
//  Created by Aliaksandr Taustyha on 11/2/18.
//  Copyright © 2018 Aliaksandr Taustyha. All rights reserved.
//

import Foundation
import ObjectMapper
import Alamofire

class ShowListRequest: WebServiceRequest {
    
    override var tag: WebServiceTag? {
        return WebServiceTag.showList
    }
    
    init() {
        super.init()
        self.method = .get
    }
    
    required init(endpoint: String?, method: HTTPMethod, parameters: [String : Any]?, encoding: ParameterEncoding, headers: [String : String]?, identifier: String?) {
        fatalError("init(endpoint:method:parameters:encoding:headers:identifier:) has not been implemented")
    }
    
}

class ShowListResponse: WebServiceResponse {
    
    private(set) var result: [ShowWebModel] = []
    
    override func parseArray(_ data: [AnyObject]) {
        for object in data {
            guard let json = object as? [String : Any], let show = ShowWebModel(JSON: json) else {
                continue
            }
            
            result.append(show)
        }
    }
}

class ShowListService: WebService<ShowListRequest, ShowListResponse> {

}

class ShowListCommand: Command<ShowListRequest, ShowListResponse> {

    internal override func constructService() -> WebService<ShowListRequest, ShowListResponse>? {
        return factory.showListService()
    }
}
