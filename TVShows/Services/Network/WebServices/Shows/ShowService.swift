//
//  ShowService.swift
//  TVShows
//
//  Created by Aliaksandr Taustyha on 11/2/18.
//  Copyright © 2018 Aliaksandr Taustyha. All rights reserved.
//

import Foundation
import ObjectMapper

class ShowRequest: WebServiceRequest {
    
    private(set) var id: String = ""
    
    override var tag: WebServiceTag? {
        return WebServiceTag.show
    }
    
    convenience init(identifier: String) {
        self.init()
        self.id = identifier
        self.method = .get
    }
    
    override func constructEndpoint() -> String? {
        if let value = super.constructEndpoint() {
            self.endpoint = value + id
            return value + id
        }
        return nil
    }
}

class ShowResponse: WebServiceResponse {
    
    private(set) var result: ShowWebModel?
    
    override func parseDataDictionary(_ data: [String : AnyObject]) {
        result = ShowWebModel(JSON: data)
    }
}

class ShowService: WebService<ShowRequest, ShowResponse> {
    
}

class ShowCommand: Command<ShowRequest, ShowResponse> {
    
    internal override func constructService() -> WebService<ShowRequest, ShowResponse>? {
        return factory.showService()
    }
}
