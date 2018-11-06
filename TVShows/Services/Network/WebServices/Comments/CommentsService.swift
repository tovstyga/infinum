//
//  CommentsService.swift
//  TVShows
//
//  Created by Aliaksandr Taustyha on 11/2/18.
//  Copyright © 2018 Aliaksandr Taustyha. All rights reserved.
//

import Foundation
import ObjectMapper

class CommentsRequest: WebServiceRequest {
    
    private(set) var episodeIdentifier: String?
    
    convenience init(episodeIdentifier: String) {
        self.init()
        self.episodeIdentifier = episodeIdentifier
        self.method = .get
    }
    
    override var tag: WebServiceTag? {
        return WebServiceTag.comments
    }
    
    override func constructEndpoint() -> String? {
        if let value = super.constructEndpoint(), let id = episodeIdentifier {
            let result = String(format: value, id)
            self.endpoint = result
            return result
        }
        return nil
    }
    
}

class CommentsResponse: WebServiceResponse {
    
    private(set) var result: [CommentWebModel] = []
    
    override func parseDataArray(_ data: [AnyObject]) {
        for object in data {
            guard let json = object as? [String : Any], let comment = CommentWebModel(JSON: json) else {
                continue
            }
            
            result.append(comment)
        }
    }
}

class CommentsService: WebService<CommentsRequest, CommentsResponse> {
    
}

class CommentsCommand: Command<CommentsRequest, CommentsResponse> {
    
    internal override func constructService() -> WebService<CommentsRequest, CommentsResponse>? {
        return factory.commentsService()
    }
}
