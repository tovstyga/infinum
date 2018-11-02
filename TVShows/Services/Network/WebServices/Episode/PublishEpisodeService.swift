//
//  PublishEpisodeService.swift
//  TVShows
//
//  Created by Aliaksandr Taustyha on 11/2/18.
//  Copyright © 2018 Aliaksandr Taustyha. All rights reserved.
//

import Foundation
import ObjectMapper

class PublishEpisodeRequest: WebServiceRequest {
    
    private(set) var showId: String?
    private(set) var mediaId: String?
    private(set) var title: String?
    private(set) var info: String?
    private(set) var episodeNumber: String?
    private(set) var season: String?
    
    override var tag: WebServiceTag? {
        return WebServiceTag.addEpisode
    }
    
    convenience init(showId: String, mediaId:String, title: String?, info: String?, number: String?, season: String?) {
        self.init()
        self.showId = showId
        self.mediaId = mediaId
        self.title = title
        self.info = info
        self.episodeNumber = number
        self.season = season
    }
    
    override func normalize() -> [String : Any]? {
        let result = DictionaryBuilder()
            .add(super.normalize())
            .add("showId", value: showId)
            .add("mediaId", value: mediaId)
            .add("title", value: title)
            .add("description", value: info)
            .add("episodeNumber", value: episodeNumber)
            .add("season", value: episodeNumber)
            .build()
        return result
    }
}

class PublishEpisodeResponse: WebServiceResponse {
    
    required init(source: AnyObject?, error: Error?, statusCode: Int?) {
        super.init(source: source, error: error, statusCode: statusCode)
        status = statusCode == 201 ? .success : .error
        self.error = self.error ?? NSError.commonError
    }
    
}

class PublishEpisodeService: WebService<PublishEpisodeRequest, PublishEpisodeResponse> {
    
}

class PublishEpisodeCommand: Command<PublishEpisodeRequest, PublishEpisodeResponse> {
    
    internal override func constructService() -> WebService<PublishEpisodeRequest, PublishEpisodeResponse>? {
        return factory.publishEpisodeService()
    }
}
