//
//  EpisodeService.swift
//  TVShows
//
//  Created by Aliaksandr Taustyha on 11/2/18.
//  Copyright © 2018 Aliaksandr Taustyha. All rights reserved.
//

import Foundation
import ObjectMapper

class EpisodeRequest: WebServiceRequest {
    
    private(set) var id: String = ""
    
    override var tag: WebServiceTag? {
        return WebServiceTag.episode
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

class EpisodeResponse: WebServiceResponse {
    
    private(set) var result: EpisodeWebModel?
    
    override func parseDataDictionary(_ data: [String : AnyObject]) {
        result = EpisodeWebModel(JSON: data)
    }
}

class EpisodeService: WebService<EpisodeRequest, EpisodeResponse> {
    
}

class EpisodeCommand: Command<EpisodeRequest, EpisodeResponse> {
    
    internal override func constructService() -> WebService<EpisodeRequest, EpisodeResponse>? {
        return factory.episodeService()
    }
}
