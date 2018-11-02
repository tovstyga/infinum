//
//  PublishCommentService.swift
//  TVShows
//
//  Created by Aliaksandr Taustyha on 11/2/18.
//  Copyright © 2018 Aliaksandr Taustyha. All rights reserved.
//

import Foundation
import ObjectMapper

class PublishCommentRequest: WebServiceRequest {
    
    private(set) var text: String?
    private(set) var episodeId: String?
    
    override var tag: WebServiceTag? {
        return WebServiceTag.addComment
    }
    
    convenience init(episodeId: String, text:String) {
        self.init()
        self.text = text
        self.episodeId = episodeId
    }
    
    override func normalize() -> [String : Any]? {
        let result = DictionaryBuilder()
            .add(super.normalize())
            .add("text", value: text)
            .add("episodeId", value: episodeId)
            .build()
        return result
    }
}

class PublishCommentResponse: WebServiceResponse {
    
    private(set) var result: CommentWebModel?
    
    override func parseDictionary(_ data: [String : AnyObject]) {
        result = CommentWebModel(JSON: data)
    }
    
}

class PublishCommentService: WebService<PublishCommentRequest, PublishCommentResponse> {
    
}

class PublishCommentCommand: Command<PublishCommentRequest, PublishCommentResponse> {
    
    internal override func constructService() -> WebService<PublishCommentRequest, PublishCommentResponse>? {
        return factory.publishCommentService()
    }
}
