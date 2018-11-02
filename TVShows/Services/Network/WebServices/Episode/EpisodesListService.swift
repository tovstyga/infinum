//
//  EpisodesListService.swift
//  TVShows
//
//  Created by Aliaksandr Taustyha on 11/2/18.
//  Copyright © 2018 Aliaksandr Taustyha. All rights reserved.
//

import Foundation
import ObjectMapper

class EpisodesListRequest: WebServiceRequest {
    
    private(set) var showIdentifier: String?
    
    convenience init(showIdentifier: String) {
        self.init()
        self.showIdentifier = showIdentifier
        self.method = .get
    }
    
    override var tag: WebServiceTag? {
        return WebServiceTag.episodes
    }
    
    override func constructEndpoint() -> String? {
        if let value = super.constructEndpoint(), let id = showIdentifier {
            let result = String(format: value, id)
            self.endpoint = result
            return result
        }
        return nil
    }
    
}

class EpisodesListResponse: WebServiceResponse {
    
    private(set) var result: [EpisodeWebModel] = []
    
    override func parseArray(_ data: [AnyObject]) {
        for object in data {
            guard let json = object as? [String : Any], let episode = EpisodeWebModel(JSON: json) else {
                continue
            }
            
            result.append(episode)
        }
    }
}

class EpisodesListService: WebService<EpisodesListRequest, EpisodesListResponse> {
    
}

class EpisodesListCommand: Command<EpisodesListRequest, EpisodesListResponse> {
    
    internal override func constructService() -> WebService<EpisodesListRequest, EpisodesListResponse>? {
        return factory.episodesListService()
    }
}
