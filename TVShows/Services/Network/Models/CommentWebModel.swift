//
//  CommentWebModel.swift
//  TVShows
//
//  Created by Aliaksandr Taustyha on 11/2/18.
//  Copyright © 2018 Aliaksandr Taustyha. All rights reserved.
//

import Foundation
import ObjectMapper

struct CommentWebModel: Mappable {
    
    private(set) var episodeId: String?
    private(set) var text: String?
    private(set) var userEmail: String?
    private(set) var id: String?
    private(set) var userId: String?
    private(set) var type: String?
    
    private enum Keys: String {
        case episodeId = "episodeId"
        case text = "text"
        case userEmail = "userEmail"
        case id = "_id"
        case type = "type"
        case userId = "userId"
    }
    
    init?(map: Map) {
        episodeId = try? map.value(Keys.episodeId.rawValue)
        text = try? map.value(Keys.text.rawValue)
        userEmail = try? map.value(Keys.userEmail.rawValue)
        id = try? map.value(Keys.id.rawValue)
        userId = try? map.value(Keys.userId.rawValue)
        type = try? map.value(Keys.type.rawValue)
    }
    
    mutating func mapping(map: Map) {
        episodeId <- map[Keys.episodeId.rawValue]
        text <- map[Keys.text.rawValue]
        userEmail <- map[Keys.userEmail.rawValue]
        id <- map[Keys.id.rawValue]
        userId <- map[Keys.userId.rawValue]
        type <- map[Keys.type.rawValue]
    }
    
}
